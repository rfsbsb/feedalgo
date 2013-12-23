class AddFaviconToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :favicon, :string
  end
end
