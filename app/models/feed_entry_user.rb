class FeedEntryUser < ActiveRecord::Base
  attr_accessible :favorite, :feed_entry_id, :feed_id, :read, :user_id
end
