class AddMd5ToImages < ActiveRecord::Migration
  def change
    add_column :images, :md5, :string
  end
end
