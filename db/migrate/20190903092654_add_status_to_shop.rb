class AddStatusToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :status, :boolean,default: false
  end
end
