class PagesController < ApplicationController
  def home
  end

  def feed
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @feed).all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def folder
    @folder = Folder.find_by_url(params[:id])
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

  def show_all_folder
  end


end
