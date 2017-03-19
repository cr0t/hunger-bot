ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :name
      row :email
      row :role
      row :address
      div do
        render 'shared/map', lat: user.lat, lng: user.lng
      end
    end
  end

  permit_params do
    permitted = [:email, :name, :password, :password_confirmation, :address]
  end
end
