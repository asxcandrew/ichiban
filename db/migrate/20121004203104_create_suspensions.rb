class CreateSuspensions < ActiveRecord::Migration
  def change
    create_table :suspensions do |t|
      t.date :ends_at
      t.integer :post_id
      t.text :reason

      t.timestamps
    end
  end
end
