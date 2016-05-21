class RemoveRepliesAndNames < ActiveRecord::Migration
  def change
    remove_column :posts, :replies
    remove_column :posts, :name
  end
end
