class BaseHandler
  RESPONDERS_MAPPING = YAML.load_file(Rails.root.join('app', 'handlers', 'data.yml')).freeze
  RESPONDERS_HASH = RESPONDERS_MAPPING.reduce({}) do |acc, (state, keywords)|
    keywords.each { |keyword| acc[keyword] = state }
    acc
  end.freeze

  ACTIONS = [
    'checkout_confirm',
    'checkout_reject',
    'clean_confirm',
    'clean_reject',
    'browse_categories_add_item'
  ]

  def initialize(session)
    @session = session
  end

  def handle_message(message)
    @message = message
    if step && RESPONDERS_MAPPING.include?(step)
      @session[:current_step] = step
    elsif step
      fail "Unknown state: #{next_step}"
    end
  end

  def handle_callback(callback_query)
    callback_data = begin
      JSON.parse(callback_query)
    rescue
      {}
    end.with_indifferent_access

    action = "#{@session[:current_step]}_#{callback_data[:action]}"
    puts action
    return unless action.in?(ACTIONS)
    self.send(action.to_sym, callback_data[:data])
  end

  def response
    responder.response
  end

  def should_handle?
    !!step
  end

  def checkout_confirm(*)
    # Create order here...
    @session[:current_step] = nil
    @session[:cart] = []
  end

  def checkout_reject(*)
    # Do nothing
  end

  def clean_confirm(*)
    @session[:cart] = []
  end

  def clean_reject(*)
    # Do nothing
  end

  def browse_categories_add_item(data)
    @session[:cart] ||= []
    @session[:cart] << data
  end

  private

  def responder
    @responder ||= case step
      when 'browse_categories'
        CollectionResponder.new(
          prompt: 'Какая категория вас интересует?',
          collection: [
            {text: '1', id: '1'},
            {text: '2', id: '2'}
          ],
          get_text: ->(item) { item[:text] },
          get_callback: ->(item) { {action: 'add_item', data: {id: item[:id]}} }
        )
      when 'clean'
        BooleanResponder.new(prompt: 'Удалить заказ?')
      when 'checkout'
        BooleanResponder.new(prompt: 'Оформим заказ?')
      else FallbackResponder.new
    end
  end

  def step
    @next_step ||= tokens.reduce(nil) do |acc, token|
      RESPONDERS_HASH[token.downcase] || acc
    end
  end

  def tokens
    return [] unless @message
    @tokens ||= @message['text'].try! do |text|
      text.split(/\,|\.|\:|\s|\?|\"|\'/)
    end || []
  end
end
