class AddFieldToPost < ActiveRecord::Migration
  def change
    add_column :posts, :addition_id, :integer
  end
end
