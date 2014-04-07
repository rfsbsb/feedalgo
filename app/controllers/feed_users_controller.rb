class FeedUsersController < ApplicationController
  before_filter :authenticate_user!
  def xeditable? object = nil
    true
  end

  def rename
    @feed = current_user.feeds.find_by_url(params[:id])
    respond_to do |format|
      if @feed.feed_users.first.update_attributes(params[:feed_user])
        format.json { head :no_content } # 204 No Content
      else
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

end