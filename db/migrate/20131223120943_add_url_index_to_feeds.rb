class AddUrlIndexToFeeds < ActiveRecord::Migration
  def change
    add_index :feeds, :url
  end
end
