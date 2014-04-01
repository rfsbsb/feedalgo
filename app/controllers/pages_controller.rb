class PagesController < ApplicationController
  def home
  end

  def feed
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @feed)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def folder
    @folder = current_user.folders.find_by_name(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @folder.feeds)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def mark_as_read
    @entry = current_user.feed_entry_users.find(params[:id])
    @entry.toggle_read
    num_feeds = current_user.feed_entry_users.where(:feed_id => @entry.feed_id).where('feed_entry_users.read = ? or feed_entry_users.read is NULL',false).count()
    @feed_count = num_feeds <= 0 ? nil : num_feeds
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

  def show_unread
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @feed)
    respond_to do |format|
      format.js {render :action => :feed}
      format.html {render :action => :feed}
    end
  end

  def folder_unread
    @folder = current_user.folders.find_by_name(params[:id])
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @folder.feeds)
    respond_to do |format|
      format.js {render :action => :folder}
      format.html {render :action => :folder}
    end
  end

  def mark_all_read
    @feed = current_user.feeds.find_by_url(params[:id])
    query = current_user.feed_entry_users.unread.where(:feed_id => @feed)

    case params[:period].downcase
      when 'day'
        query.day_older.joins(:feed_entry).update_all(:read => true)
      when 'week'
        query.week_older.joins(:feed_entry).update_all(:read => true)
      when 'month'
        query.month_older.joins(:feed_entry).update_all(:read => true)
      else
        query.joins(:feed_entry).update_all(:read => true)
      end

    respond_to do |format|
      format.js
    end
  end

  def mark_all_folder_read
  end

end
