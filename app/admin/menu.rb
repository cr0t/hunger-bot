ActiveAdmin.register Menu do
  menu label: 'Menu'

  index title: 'Menu' do
    selectable_column
    column :name do |menu|
      link_to menu.name, admin_menu_path(menu)
    end
    column :category
    column :price
    column :provider
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Menu Details" do
      f.input :name
      f.input :price
      f.input :category
      f.input :provider
    end
    f.actions
  end

  permit_params do
    permitted = [:category_id, :name, :price, :provider_id]
  end
end
