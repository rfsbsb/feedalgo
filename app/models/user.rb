class User < ActiveRecord::Base
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  attr_accessible :role_ids, :as => :admin
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :folders
  has_many :feed_entry_users
  has_many :feed_entries, :through => :feed_entry_users
  has_many :feed_users
  has_many :feeds, :through => :feed_users, select: "feeds.*, feed_users.title, feed_users.folder_id"

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first

      # Uncomment the section below if you want users to be created if they don't exist
      unless user
          user = User.create(
             email: data["email"],
             password: Devise.friendly_token[0,20]
          )
      end
      user
  end

end
