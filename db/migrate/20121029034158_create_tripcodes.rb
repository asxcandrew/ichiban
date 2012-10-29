class CreateTripcodes < ActiveRecord::Migration
  def change
    create_table :tripcodes do |t|
      t.integer :post_id
      t.string :encryption

      t.timestamps
    end
  end
end
