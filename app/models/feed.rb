class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :favicon, :user, :folder_id

  validates :url, presence: true, url: true
  before_save :get_title_before_save
  after_save  :create_user_relationship

  has_many :feed_users
  has_many :feed_entries
  has_many :feed_entry_users

  scope :ordered, order("feed_users.title ASC")
  scope :leaf, where("feed_users.folder_id IS NULL OR feed_users.folder_id = ?", 0)

  def user
    @user
  end

  def user= (val)
    @user = val
  end

  def folder_id
    @folder_id
  end

  def folder_id= (val)
    @folder_id = val
  end

  protected
    def get_title_before_save
      crawler = Crawler.new
      feed = crawler.is_feed(self.url)

      if (feed)
        self.title = feed.title
        return true
      end

      errors.add(:url, "invalid RSS url.")
      return false
    end

    def create_user_relationship
      feed_user = FeedUser.new
      feed_user.feed_id = self.id
      feed_user.user_id = self.user.id
      feed_user.title = self.title
      feed_user.folder_id = self.folder_id
      if feed_user.save
        crawler = Crawler.new
        crawler.update_by_id self.id
      end
    end
end
