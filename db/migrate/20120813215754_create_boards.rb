class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.string :name
      t.string :directory
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
