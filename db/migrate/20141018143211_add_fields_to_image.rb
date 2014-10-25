class AddFieldsToImage < ActiveRecord::Migration
  def change
    add_column :images, :imageable_type, :string
    add_column :images, :imageable_id, :integer
  end
end
