class Folder < ActiveRecord::Base
  attr_accessible :name, :state, :user_id

  validates :name, presence: true

  belongs_to :user
  has_many :feed_user, :dependent => :destroy
  has_many :feeds, :through => :feed_user, select: "feeds.*, feed_users.title, feed_users.folder_id"

end