class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :body, :title, :url

  def self.import (feed)
    feed.entries.each do |e|
      entry = FeedEntry.find_or_initialize_by_url(e.url)
      if entry.new_record?
        # Getting the base URL of the site
        uri = URI.parse(feed.url)
        url = "#{uri.scheme}://#{uri.host}"
        body = nil
        if e.respond_to?(:content) && !e.content.nil?
          body = e.content
        elsif e.respond_to?(:summary) && !e.summary.nil?
          body = e.summary
        end

        # Parsing the body correctly
        if body
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
          entry.body = doc.xpath("//body").to_html
        end

        entry.title  = e.title
        entry.body = body
        entry.author = e.author if e.author
        entry.save
      end
    end
  end
end
