class User < ActiveRecord::Base
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :role_ids, :as => :admin
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :folders
  has_many :feed_entry_users
  has_many :feed_entries, :through => :feed_entry_users
  has_many :feed_users
  has_many :feeds, :through => :feed_users, select: "feeds.*, feed_users.title, feed_users.folder_id"

end
