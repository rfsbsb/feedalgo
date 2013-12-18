class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :body, :title, :url

  def self.import (feed)
    feed.entries.each do |e|
      entry = FeedEntry.find_or_initialize_by_url(e.url)
      if entry.new_record?
        entry.title  = e.title

        body = nil
        if e.respond_to?(:content) && !e.content.nil?
          body = e.content
        elsif e.respond_to?(:summary) && !e.summary.nil?
          body = e.summary
        end

        entry.body = body
        entry.author = e.author if e.author
        entry.save
      end
    end
  end
end
