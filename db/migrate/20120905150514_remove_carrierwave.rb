class RemoveCarrierwave < ActiveRecord::Migration
  def change
    remove_column :posts, :image
    remove_column :posts, :image_height
    remove_column :posts, :image_width

    remove_column :posts, :thumbnail_height
    remove_column :posts, :thumbnail_width
  end
end
