class RemoveColorFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :color
  end
end
