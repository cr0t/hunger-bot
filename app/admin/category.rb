ActiveAdmin.register Category do
  permit_params do
    permitted = [:name]
  end
end
