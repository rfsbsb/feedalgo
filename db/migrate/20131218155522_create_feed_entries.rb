class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.text :body
      t.string :url, :limit => 500
      t.string :author

      t.timestamps
    end
  end
end
