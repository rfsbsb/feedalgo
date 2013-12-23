class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :body, :title, :url
end
