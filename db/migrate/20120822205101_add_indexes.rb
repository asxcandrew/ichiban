class AddIndexes < ActiveRecord::Migration
  def change
    add_index :boards, :directory, unique: true
    add_index :operators, :email
    
    add_index :posts, :parent_id
    add_index :posts, :directory
  end
end
