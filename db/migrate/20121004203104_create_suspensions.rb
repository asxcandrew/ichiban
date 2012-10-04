class CreateSuspensions < ActiveRecord::Migration
  def change
    create_table :suspensions do |t|
      t.string :ip_address
      t.date :ends_at
      t.integer :post_id
      t.string :directory
      t.text :reason

      t.timestamps
    end
  end
end
