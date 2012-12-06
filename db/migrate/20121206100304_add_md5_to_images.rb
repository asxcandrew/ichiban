class AddMd5ToImages < ActiveRecord::Migration
  def change
    add_column :images, :md5, :integer
  end
end
