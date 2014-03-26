class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :fetch_feeds_sidebar

  def fetch_feeds_sidebar
    @folders = current_user.folders.all
  end
end
