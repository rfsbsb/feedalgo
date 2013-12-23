class AddUrlIndexToFeedEntries < ActiveRecord::Migration
  def change
    add_index :feed_entries, :url
  end
end
