class FeedUser < ActiveRecord::Base
  attr_accessible :feed_id, :folder_id, :title, :user_id
  belongs_to :user
  belongs_to :feed
end
