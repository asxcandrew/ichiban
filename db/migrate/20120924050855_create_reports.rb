class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :ip_address
      t.string :model
      t.integer :post_id
      t.text :comment

      t.timestamps
    end
  end
end
