class Crawler
  def run()
    feeds = Feed.pluck(:url)
    fetch_and_persist(feeds)
  end

  def fetch_and_persist(feeds)
    Feedzirra::Feed.fetch_and_parse(feeds, :on_success => lambda {|url, feed| persist(url, feed)})
  end

  def persist(url, import_feed)
    feed = Feed.find_or_initialize_by_url(url)
    if feed.new_record?
      feed.title = import_feed.title
      feed.save
    end
    persist_entry(import_feed.entries, feed)
  end

  def persist_entry(entries, feed)
    entries.each do |e|
      entry = FeedEntry.find_or_initialize_by_url(e.url)
      if entry.new_record?
        body = nil
        if e.respond_to?(:content) && !e.content.nil?
          body = e.content
        elsif e.respond_to?(:summary) && !e.summary.nil?
          body = e.summary
        end

        entry.body = parse_body(body, feed)
        entry.title  = e.title
        entry.feed_id = feed.id
        entry.body = body
        entry.author = e.author if e.author
        entry.save
      end
    end
  end

  def parse_body(body, feed)
    if body
      # Getting the base URL of the site
      uri = URI.parse(feed.url)
      url = "#{uri.scheme}://#{uri.host}"
      body = Sanitize.clean(body, Sanitize::Config::RELAXED)
      doc = Nokogiri::HTML(body)
      # Image parsing
      doc.search("img").each do |img|
        # Turning the image path absolute
        if !img['src'].nil? && !img['src'].match(/^http/)
          img['data-original'] = url + img['src']
        else
          img['data-original'] = img['src']
        end
        # Adding preloading data
        img['src'] = "/assets/preloader.gif"
        img['class'] = "img-polaroid img-rounded"
      end

      # Adding formatting classes for tables
      doc.search("table").each do |table|
        table['class'] = "table table-bordered table-striped table-condensed"
      end

      # Link parsing
      doc.search("a").each do |link|
        # Turning the link path absolute and opening in a new window
        if !link['href'].nil? && !link['href'].match(/^http/)
          link['href'] = url + link['href']
        end
        link['target'] = "_blank"
      end

      doc.xpath('//comment()').remove
      doc.xpath("//body").to_html
    end
  end

end
