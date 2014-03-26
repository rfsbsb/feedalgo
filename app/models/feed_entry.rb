class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :body, :title, :url, :feed_id
  belongs_to :feed
  has_many :feed_entry_users
end
