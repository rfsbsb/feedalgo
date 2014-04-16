class FeedUsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @feed = current_user.feeds.find(params[:id])
    @feed_user = current_user.feed_users.find_by_feed_id(@feed)
    @folders = current_user.folders.all
    respond_to do |format|
      format.js
    end
  end

  def update
    @feed_user = current_user.feed_users.find(params[:id])
    @feed = current_user.feeds.find(@feed_user.feed_id)
    @folders = current_user.folders.all
    respond_to do |format|
      if @feed_user.update_attributes(params[:feed_user])
        format.js {
          flash[:notice] = 'The feed was successfully updated.'
        }
      else
        format.js
      end
    end
  end

  def unsubscribe
    @feed_user = current_user.feed_users.find(params[:id])
    respond_to do |format|
      if @feed_user.destroy && current_user.feed_entry_users.where(:feed_id => @feed_user.feed_id).destroy_all
        format.js {
          flash[:notice] = "You have successfully unsubscribed to the \"#{@feed_user.title}\" feed."
          flash.keep(:notice)
          render js: "window.location = '#{root_path}'"
        }
      else
        format.js
      end
    end
  end

end