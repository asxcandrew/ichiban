class AddAddition < ActiveRecord::Migration
  def self.up
    create_table :additions do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :additions
  end
end
