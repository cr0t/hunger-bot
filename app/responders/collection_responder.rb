class CollectionResponder < BaseResponder
  def initialize(options)
    @options = options
  end

  def response
    {
      text: @options[:prompt],
      reply_markup: {
        inline_keyboard: [items]
      }
    }
  end

  def items
    @options[:collection].map do |item|
      {
        text: @options[:get_text].call(item),
        callback_data: @options[:get_callback].call(item).to_json
      }
    end
  end
end
