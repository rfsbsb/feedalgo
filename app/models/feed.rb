class Feed < ActiveRecord::Base
  attr_accessible :title, :url

  def self.import
    feeds = Feed.pluck(:url)
    Feedzirra::Feed.fetch_and_parse(feeds, :on_success => lambda {|url, feed| Feed.import_success(url, feed)})
  end

  def self.import_success (url, import_feed)
    feed = Feed.find_or_initialize_by_url(url)
    if feed.new_record?
      feed.title = import_feed.title
      feed.save
    end
    FeedEntry.import(import_feed)
  end

end
