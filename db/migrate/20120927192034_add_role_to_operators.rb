class AddRoleToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :role_id, :integer
  end
end
