class ReplaceDirectoryWithBoardId < ActiveRecord::Migration
  def change
    remove_column :posts, :directory
    remove_column :suspensions, :directory
    add_column :posts, :board_id, :integer
    add_column :suspensions, :board_id, :integer    
  end
end
