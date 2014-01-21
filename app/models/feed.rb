class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :favicon
  validates :title, presence: true
  validates :url, presence: true, url: true
end