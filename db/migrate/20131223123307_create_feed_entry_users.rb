class CreateFeedEntryUsers < ActiveRecord::Migration
  def change
    create_table :feed_entry_users do |t|
      t.integer :feed_id
      t.integer :feed_entry_id
      t.integer :user_id
      t.boolean :read
      t.boolean :favorite
    end
    add_index :feed_entry_users, :feed_id
    add_index :feed_entry_users, :feed_entry_id
    add_index :feed_entry_users, :user_id
  end
end
