class AddHexToPost < ActiveRecord::Migration
  def change
    add_column :posts, :tripcode_hex, :string
  end
end
