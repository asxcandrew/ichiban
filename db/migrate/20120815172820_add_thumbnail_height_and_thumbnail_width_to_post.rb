class AddThumbnailHeightAndThumbnailWidthToPost < ActiveRecord::Migration
  def change
    add_column :posts, :thumbnail_height, :string
    add_column :posts, :thumbnail_width, :string
  end
end
