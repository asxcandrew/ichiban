class AddRelatedIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :related_id, :integer, :unique => true, :null => false
  end
end
