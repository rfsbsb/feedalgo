class AddFeedRefToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :feed_id, :integer
    add_index :feed_entries, :feed_id
  end
end
