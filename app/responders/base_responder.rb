class BaseResponder
  RESPONDERS_MAPPING = {
    'меню' => CategoriesResponder,
    'рестораны' => RestaurantsResponder
  }.freeze

  def self.responder_for(text)
    responder = tokenize(text).reduce(nil) do |acc, token|
      RESPONDERS_MAPPING[token]
    end || FallbackResponder
    responder.new
  end

  def self.tokenize(text)
    text.split(/\,|\.|\:|\s+|\?|\"|\'/)
  end

  def response
    {
      text: self.text,
      reply_markup: {
        inline_keyboard: self.items
      }
    }
  end

  def text
    fail 'Not implemented'
  end
end
