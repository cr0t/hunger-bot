ActiveAdmin.register Order do
  permit_params do
    permitted = [:menu_id, :quantity, :amount, :address, :contacts, :customer_id, :provider_id]
  end
end
