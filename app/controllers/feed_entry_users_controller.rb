class FeedEntryUsersController < ApplicationController
  before_filter :authenticate_user!
  def mark_as_read
    @entry = current_user.feed_entry_users.find(params[:id])
    @entry.toggle_read
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @entry.feed_id).count()
    respond_to do |format|
      format.js
    end
  end

  def favorite
    @entry = current_user.feed_entry_users.find(params[:id])
    @entry.toggle_favorite
    respond_to do |format|
      format.js
    end
  end

  def mark_all_read
    @feeds = current_user.feeds
    current_user.feed_entry_users.update_by_period(@feeds, params[:period])
    @entries = current_user.feed_entry_users.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :template => "feeds/all"}
      format.html {render :template => "feeds/all"}
    end
  end

  def mark_all_feed_read
    @feed = current_user.feeds.find_by_url(params[:id])
    @feed_users = @feed.feed_users.first
    current_user.feed_entry_users.update_by_period(@feed, params[:period])

    @entries = current_user.feed_entry_users.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()

    respond_to do |format|
      format.js {render :template => "feeds/list"}
      format.html {render :template => "feeds/list"}
    end
  end

  def mark_all_folder_read
    @folder = current_user.folders.find(params[:id])
    current_user.feed_entry_users.update_by_period(@folder.feeds, params[:period])

    @entries = current_user.feed_entry_users.where(:feed_id => @folder.feeds).paginate(:page => params[:page])

    respond_to do |format|
      format.js {render :template => "folders/list"}
      format.html {render :template => "folders/list"}
    end
  end

end