class BooleanResponder < BaseResponder
  DEFAULT_CONFIRM_TEXT = 'Да'
  DEFAULT_REJECT_TEXT = 'Нет'

  def initialize(options)
    @options = options
  end

  def response
    {
      text: @options[:prompt],
      reply_markup: {
        inline_keyboard: items
      }
    }
  end

  def items
    [
      [{
        text: @options[:confirm_text] || DEFAULT_CONFIRM_TEXT,
        callback_data: {action: 'confirm'}.to_json
      }],
      [{
        text: @options[:reject_text] || DEFAULT_REJECT_TEXT,
        callback_data: {action:'reject'}.to_json
      }]
    ]
  end
end
