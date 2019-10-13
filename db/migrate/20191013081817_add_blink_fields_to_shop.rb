class AddBlinkFieldsToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :blink_speed, :float,default: 1.5
    add_column :shops, :blink_color, :string,default: "rgba(255, 255, 255, 0.4)"
    add_column :shops, :blink_wider, :string,default: "10px"
  end
end
