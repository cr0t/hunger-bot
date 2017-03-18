ActiveAdmin.register Order do
  form(html: { multipart: true }) do |f|
    f.semantic_errors
    inputs do
      f.input :menu, as: :select
      f.input :quantity
      f.input :amount
      f.input :address
      f.input :contacts
      f.input :customer, as: :select, value_method: id, collection: User.customers, include_blank: false
      f.input :provider, as: :select, value_method: id, collection: User.providers, include_blank: false
    end

    f.actions
  end

  permit_params do
    permitted = [:menu_id, :quantity, :amount, :address, :contacts, :customer_id, :provider_id]
  end
end
