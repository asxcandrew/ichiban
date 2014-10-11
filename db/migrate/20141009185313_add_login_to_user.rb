class AddLoginToUser < ActiveRecord::Migration
  def change
    add_column :users, :login, :string, :unique => true
  end
end
