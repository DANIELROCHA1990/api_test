class RenameTypeToProductType < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :type, :product_type
  end
end
