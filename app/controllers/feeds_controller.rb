class FeedsController < ApplicationController
  before_filter :authenticate_user!
  def list
    @feed = current_user.feeds.find_by_url(params[:id])
    @feed_users = @feed.feed_users.first
    @entries = current_user.feed_entry_users.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js
      format.html
    end
  end

  def list_paging
    @feed = current_user.feeds.find_by_url(params[:id])
    @feed_users = @feed.feed_users.first
    @entries = current_user.feed_entry_users.where(:feed_id => @feed).paginate(:page => params[:page])
    respond_to do |format|
      format.js
    end
  end

  def unread
    @feed = current_user.feeds.find_by_url(params[:id])
    @feed_users = @feed.feed_users.first
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @feed).paginate(:page => params[:page])
    @feed_count = current_user.feed_entry_users.unread.where(:feed_id => @feed).count()
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def all
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def all_paging
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def all_unread
    @feeds = current_user.feeds.all
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :action => :all}
      format.html {render :action => :all}
    end
  end

  def new
    @feed = Feed.new
    respond_to do |format|
      format.js
    end
  end

  def create
    params[:feed][:user] = current_user
    @feed = Feed.new(params[:feed])
    debugger
    respond_to do |format|
      if @feed.save
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

end