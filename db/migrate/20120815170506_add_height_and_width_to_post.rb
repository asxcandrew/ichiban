class AddHeightAndWidthToPost < ActiveRecord::Migration
  def change
    add_column :posts, :image_height, :string
    add_column :posts, :image_width, :string
  end
end
