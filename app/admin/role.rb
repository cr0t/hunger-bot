ActiveAdmin.register Role do
  permit_params do
    permitted = [:name]
  end
end
