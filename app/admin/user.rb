ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column :name
    column :address
    column :role
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "Admin Details" do
      f.input :email, input_html: { disabled: true }
      f.input :name
      f.input :address, input_html: { rows: 1 }
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
