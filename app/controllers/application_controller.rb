class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :fetch_feeds_sidebar
  helper_method :xeditable?

  def fetch_feeds_sidebar
    if current_user != nil
      @folders = current_user.folders.all
      @feeds = current_user.feeds.ordered.where("feed_users.folder_id IS NULL OR feed_users.folder_id = ?", false)
      @unread = current_user.feed_entries.unread.count(:group => 'feed_entry_users.feed_id')
    end
  end
  def xeditable? object = nil
    true
  end
end
