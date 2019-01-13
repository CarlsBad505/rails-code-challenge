class AddExpediteToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :expedite, :boolean, default: false
  end
end
