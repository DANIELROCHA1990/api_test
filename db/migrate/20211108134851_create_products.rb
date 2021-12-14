class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :type
      t.text :description
      t.string :filename
      t.integer :height
      t.integer :width
      t.float :price
      t.integer :rating

      t.timestamps
    end
  end
end
