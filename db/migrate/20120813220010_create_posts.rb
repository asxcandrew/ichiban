class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.string :subject
      t.string :ip_address
      t.text :body
      t.string :tripcode
      t.string :directory
      t.integer :parent_id  

      t.timestamps
    end
  end
end
