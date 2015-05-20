class Importer

  attr_accessor :feeds
  attr_accessor :invalids
  attr_accessor :user

  def initialize(file, user)
    self.feeds = []
    self.invalids = []
    self.user = user
    opml = OpmlSaw::Parser.new(file.read)
    opml.parse
    self.feeds = opml.feeds
  end

  def import
    if self.feeds.size > 0
      for feed in self.feeds
        old_feed = Feed.find_by_url(feed[:xml_url])
        folder = nil
        if feed[:tag] != nil
          folder = Folder.find_or_initialize_by_name(feed[:tag])
          folder.user = self.user
          folder.save
        end

        if old_feed
          begin
            feed_user = FeedUser.new()
            feed_user.url = feed[:xml_url]
            feed_user.user = self.user
            feed_user.save
            if folder
              feed_user.folder_id = folder
            end
          rescue
            self.invalids.append(feed[:title])
          end
        else
          feed = Feed.new(title: feed[:title], url: feed[:xml_url])
          feed.user = self.user
          if folder
            feed.folder_id = folder.id
          end
          feed.save
        end
      end
    end
  end

end