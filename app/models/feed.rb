class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :favicon
  validates :title, presence: true
  validates :url, presence: true, url: true

  has_many :feed_users
  has_many :feed_entries
  has_many :feed_entry_users

  scope :ordered, order("feed_users.title ASC")

end