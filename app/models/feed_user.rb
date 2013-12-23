class FeedUser < ActiveRecord::Base
  attr_accessible :feed_id, :folder_id, :title, :user_id
end
