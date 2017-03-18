class CategoriesResponder < BaseResponder
  def items
    [
      [{text: 'Суп', callback_data: {action: 'select_category', id: 1}.to_json}],
      [{text: 'Борщ', callback_data: {action: 'select_category', id: 2}.to_json}]
    ]
  end

  def text
    'Какая категория вас интересует?'
  end
end
