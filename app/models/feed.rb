class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :favicon, :user
  validates :url, presence: true, url: true
  before_save :get_title_before_save
  after_save  :create_user_relationship

  has_many :feed_users
  has_many :feed_entries
  has_many :feed_entry_users

  scope :ordered, order("feed_users.title ASC")
  scope :leaf, where("feed_users.folder_id IS NULL OR feed_users.folder_id = ?", false)

  def user
    @user
  end

  def user= (val)
    @user = val
  end

  protected
    def get_title_before_save
      crawler = Crawler.new
      debugger
      feed = crawler.is_feed(self.url)

      if (feed)
        self.title = feed.title
        return true
      end

      return false
    end

    def create_user_relationship
      feed_user = FeedUser.new
      feed_user.feed_id = self.id
      feed_user.user_id = self.user.id
      feed_user.save
    end
end