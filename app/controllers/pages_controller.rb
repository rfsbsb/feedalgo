class PagesController < ApplicationController
  def home
  end

  def feed
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js
      format.html
    end
  end

  def feed_paging
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @feed).paginate(:page => params[:page])
    respond_to do |format|
      format.js
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

  def show_unread
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @feed)
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
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
    current_user.feed_entry_users.update_by_period(@feed, params[:period])

    @entries = current_user.feed_entry_users.where(:feed_id => @feed)
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()

    respond_to do |format|
      format.js {render :action => :feed}
      format.html {render :action => :feed}
    end
  end

  def mark_all_folder_read
    @folder = current_user.folders.find_by_name(params[:id])
    current_user.feed_entry_users.update_by_period(@folder.feeds, params[:period])

    @entries = current_user.feed_entry_users.where(:feed_id => @folder.feeds)

    respond_to do |format|
      format.js {render :action => :folder}
      format.html {render :action => :folder}
    end
  end

end
