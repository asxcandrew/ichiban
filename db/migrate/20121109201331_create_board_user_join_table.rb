class CreateBoardUserJoinTable < ActiveRecord::Migration
  def change
    create_table :boards_users, :id => false do |t|
      t.integer :board_id
      t.integer :user_id
    end
  end
end
