class CreateFeedUsers < ActiveRecord::Migration
  def change
    create_table :feed_users do |t|
      t.integer :feed_id
      t.integer :user_id
      t.integer :folder_id
      t.string :title
    end
    add_index :feed_users, :feed_id
    add_index :feed_users, :user_id
    add_index :feed_users, :folder_id
  end
end
