class FeedEntryUser < ActiveRecord::Base
  attr_accessible :favorite, :feed_entry_id, :feed_id, :read, :user_id
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_entry

  self.per_page = 30

  default_scope {includes(:feed_entry, :feed).order("feed_entries.created_at DESC")}
  scope :unread, where('feed_entry_users.read = ? OR feed_entry_users.read IS NULL',false)
  scope :read, where('feed_entry_users.read = ? OR feed_entry_users.read IS NOT NULL', true)
  scope :day_older, where('feed_entries.created_at <= ?', 1.day.ago.to_date )
  scope :week_older, where('feed_entries.created_at <= ?', 7.day.ago.to_date )
  scope :month_older, where('feed_entries.created_at <= ?', 30.day.ago.to_date )

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

  def self.update_by_period (feed, period)
    feed = self.unread.where(:feed_id => feed)
    case period.downcase
      when 'day'
        feed.day_older.joins(:feed_entry).update_all(:read => true)
      when 'week'
        feed.week_older.joins(:feed_entry).update_all(:read => true)
      when 'month'
        feed.month_older.joins(:feed_entry).update_all(:read => true)
      else
        feed.joins(:feed_entry).update_all(:read => true)
      end
  end

end
