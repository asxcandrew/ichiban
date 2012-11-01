class AddRepliesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :replies, :integer
  end
end
