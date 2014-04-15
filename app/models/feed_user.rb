class FeedUser < ActiveRecord::Base
  attr_accessible :feed_id, :folder_id, :title, :user_id
  belongs_to :user
  belongs_to :feed
  after_create :associate_entries
  validates :feed_id, :uniqueness => {:scope => :user_id}

  private
    def associate_entries
      entries = FeedEntry.where(:feed_id => self.feed_id).limit(10).order("id DESC")
      entry_list = []
      entries.each do |entry|
        feu = FeedEntryUser.new
        feu.feed_id = self.feed_id
        feu.feed_entry_id = entry.id
        feu.user_id = self.user_id
        feu.save
      end
      return true
    end

end
