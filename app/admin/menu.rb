ActiveAdmin.register Menu do
  menu label: 'Menu'

  form do |f|
    f.semantic_errors
    f.inputs "Menu Details" do
      f.input :category
      f.input :name
      f.input :provider
    end
    f.actions
  end

  permit_params do
    permitted = [:category_id, :name, :price, :provider_id]
  end
end
