class FeedEntryUser < ActiveRecord::Base
  attr_accessible :favorite, :feed_entry_id, :feed_id, :read, :user_id
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_entry
  default_scope {includes(:feed_entry, :feed).order("feed_entries.created_at DESC")}

  def toggle_read
    self.read = self.read ? 0 : 1
    self.save
    return self
  end

  def toggle_favorite
    self.favorite = self.favorite ? 0 : 1
    self.save
    return self
  end

end
