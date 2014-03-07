class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :fetch_feeds_sidebar

  def fetch_feeds_sidebar
    @feeds = Feed.all
  end
end
