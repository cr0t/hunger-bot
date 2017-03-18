ActiveAdmin.register Menu do
  menu label: 'Menu'

  permit_params do
    permitted = [:category_id, :name, :price]
  end
end
