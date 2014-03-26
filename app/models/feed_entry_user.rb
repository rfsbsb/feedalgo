class FeedEntryUser < ActiveRecord::Base
  attr_accessible :favorite, :feed_entry_id, :feed_id, :read, :user_id
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_entry

end
