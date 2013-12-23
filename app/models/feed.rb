class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :favicon
end
