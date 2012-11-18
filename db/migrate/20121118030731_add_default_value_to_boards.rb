class AddDefaultValueToBoards < ActiveRecord::Migration
  def change
    change_column :boards, :save_IPs, :boolean, default: true
    change_column :boards, :worksafe, :boolean, default: true
  end
end
