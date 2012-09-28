class AddRoleToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :role, :string
  end
end
