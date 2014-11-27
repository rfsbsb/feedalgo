class FoldersController < ApplicationController
  before_filter :authenticate_user!
  def list
    @folder = current_user.folders.find(params[:id])
    @entries = current_user.feed_entry_users.where(:feed_id => @folder.feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def unread
    @folder = current_user.folders.find(params[:id])
    @entries = current_user.feed_entry_users.unread.where(:feed_id => @folder.feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def favorite
    @folder = current_user.folders.find(params[:id])
    @entries = current_user.feed_entry_users.favorite.where(:feed_id => @folder.feeds).paginate(:page => params[:page])
    respond_to do |format|
      format.js {render :action => :list}
      format.html {render :action => :list}
    end
  end

  def toggle
    folder = current_user.folders.find(params[:id])
    folder.state = folder.state ? 0 : 1
    folder.save
    render nothing: true
  end

  def new
    @folder = Folder.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @folder = Folder.new(params[:folder])
    @folder.user_id = current_user.id

    respond_to do |format|
      if @folder.save
        format.js { flash[:notice] = 'The folder was successfully created.' }
      else
        format.js
      end
    end
  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])
    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.js {
          flash[:notice] = 'The folder was successfully updated.'
        }
      else
        format.js
      end
    end
  end

  def remove
    @folder = current_user.folders.find(params[:id])
    respond_to do |format|
      if @folder.destroy
        format.js {
          flash[:notice] = "The folder was successfully removed."
        }
      else
        format.js
      end
    end
  end

end