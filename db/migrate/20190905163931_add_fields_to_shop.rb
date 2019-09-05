class AddFieldsToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :icon_type, :string
    add_column :shops, :icon_color, :string
    add_column :shops, :icon_shape, :string
  end
end
