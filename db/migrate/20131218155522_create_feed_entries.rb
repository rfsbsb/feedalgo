class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.text :body
      t.text :url
      t.string :author

      t.timestamps
    end
  end
end
