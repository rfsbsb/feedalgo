class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :fetch_feeds_sidebar
  helper_method :xeditable?

  # Assemble the sidebar
  def fetch_feeds_sidebar
    # Skip it if the call is result of an Ajax method
    unless request.xhr?
      if current_user != nil
        @folders = current_user.folders.all
        @feeds = current_user.feeds.ordered.leaf
        @unread = current_user.feed_entries.unread.count(:group => 'feed_entry_users.feed_id')
      end
    end
  end

  def xeditable? object = nil
    true
  end
end
