class AddAncestorAndLockToPost < ActiveRecord::Migration
  def change
    add_column :posts, :ancestor_id, :integer
    add_column :posts, :locked, :boolean
  end
end
