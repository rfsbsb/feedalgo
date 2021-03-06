class FeedsController < ApplicationController
  before_filter :authenticate_user!
  def list
    id = URI.unescape(params[:id])
    @feed = current_user.feeds.find_by_url(id)
    @feed_users = current_user.feed_users.find_by_feed_id(@feed)
    @entries = current_user.feed_entry_users.newest.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js
      format.html
    end
  end

  def list_paging
    id = URI.unescape(params[:id])
    @feed = current_user.feeds.find_by_url(id)
    @feed_users = current_user.feed_users.find_by_feed_id(@feed)
    @entries = current_user.feed_entry_users.newest.where(:feed_id => @feed).paginate(:page => params[:page])
    respond_to do |format|
      format.js
    end
  end

  def favorite
    id = URI.unescape(params[:id])
    @feed = current_user.feeds.find_by_url(id)
    @feed_users = current_user.feed_users.find_by_feed_id(@feed)
    @entries = current_user.feed_entry_users.favorite.newest.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def unread
    id = URI.unescape(params[:id])
    @feed = current_user.feeds.find_by_url(id)
    @feed_users = current_user.feed_users.find_by_feed_id(@feed)
    @entries = current_user.feed_entry_users.unread.newest.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def all
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.newest.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def all_paging
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.newest.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def all_unread
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.unread.newest.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :action => :all}
      format.html {render :action => :all}
    end
  end

  def all_favorite
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.favorite.newest.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :action => :favorite}
      format.html {render :action => :favorite}
    end
  end

  def all_favorite_paging
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.favorite.newest.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @feed = Feed.new
    @folders = current_user.folders.all
    respond_to do |format|
      format.js
    end
  end

  def create
    @feed = Feed.find_by_url(params[:feed][:url])
    @folders = current_user.folders.all
    if @feed
      @feed_user = FeedUser.new(feed_id: @feed.id, user_id: current_user.id, title: @feed.title, folder_id: params[:feed][:folder_id])
      @feed = Feed.new(params[:feed])
      respond_to do |format|
        if @feed_user.save
          flash.now[:notice] = 'The feed was successfully created.'
          format.js
        else
          @feed.errors.add(:url, "You already have subscribed to this feed.")
          format.js
        end
      end
    else
      @feed = Feed.new(params[:feed])
      @feed.user = current_user
      @feed.folder_id = params[:feed][:folder_id]
      respond_to do |format|
        if @feed.save
          flash.now[:notice] = 'The feed was successfully created.'
          format.js
        else
          format.js
        end
      end
    end
  end

  def import
    invalid = []
    if !params[:opml].nil?
      opml_file = params[:opml][:file]
      imp = Importer.new(opml_file, current_user)
      imp.import()
      invalid = imp.invalids
      if invalid.size > 0
        flash[:error] = 'Some feeds have problems: ' + invalid.join(", ")
      end
      flash[:notice] = 'Feeds imported.'
    end
  end

end
