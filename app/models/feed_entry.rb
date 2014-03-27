class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :body, :title, :url, :feed_id
  belongs_to :feed
  has_many :feed_entry_users

  after_save :associate_feed_entries
  default_scope {includes(:feed_entry_users, :feed).order("feed_entries.created_at DESC")}
  scope :unread, where("feed_entry_users.read IS NULL")

  # Everytime a new entry is saved, it create a relationship
  # for each user which has subscribred to the feed
  def associate_feed_entries
    feed_users = FeedUser.find_all_by_feed_id(self.feed_id)
    entry_list = []
    feed_users.each do |feed_user|
      feu = FeedEntryUser.new
      feu.feed_id = self.feed_id
      feu.feed_entry_id = self.id
      feu.user_id = feed_user.user_id
      entry_list.push(feu)
    end
    FeedEntryUser.import(entry_list)
    return true
  end

end
