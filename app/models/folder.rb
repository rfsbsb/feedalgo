class Folder < ActiveRecord::Base
  attr_accessible :name, :state, :user_id
end
