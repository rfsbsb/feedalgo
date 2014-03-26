class PagesController < ApplicationController
  def home
  end

  def feed
    @feed = current_user.feeds.find_by_url(params[:id])
    @entries = current_user.feed_entries.where(:feed_id => @feed).all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def folder
    @folder = Folder.find_by_url(params[:id])
  end

  def mark_as_read
  end

  def show_all_folder
  end

end
