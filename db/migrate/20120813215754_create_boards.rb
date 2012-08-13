class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards, id: false do |t|
      t.string :directory, primary: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
