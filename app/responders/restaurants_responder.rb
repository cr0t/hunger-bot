class RestaurantsResponder < BaseResponder
  def items
    [
      [{text: 'Ростикс', callback_data: {action: 'select_restaurant', id: 1}.to_json}],
      [{text: 'Кафе-мафе', callback_data: {action: 'select_restaurant', id: 2}.to_json}]
    ]
  end

  def text
    'В каком ресторане будем заказывать?'
  end
end
