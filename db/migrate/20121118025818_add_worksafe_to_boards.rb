class AddWorksafeToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :worksafe, :boolean
  end
end
