class UsersConfirmable < ActiveRecord::Migration
  def change
    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :unconfirmed_email, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    # add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
  end
end