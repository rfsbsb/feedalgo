class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def list
    @folder = current_user.folders.find(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @folder.feeds)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def unread
    @folder = current_user.folders.find(params[:id])
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @folder.feeds)
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def rename
    @folder = current_user.folders.find(params[:id])
    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.json { head :no_content } # 204 No Content
      else
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    folder = current_user.folders.find(params[:id])
    folder.state = folder.state ? 0 : 1
    folder.save
    render nothing: true
  end

end