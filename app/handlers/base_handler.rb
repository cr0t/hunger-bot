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
    'browse_items_add_item'
  ]

  attr_accessor :responder

  def initialize(session, customer)
    @session = session
    @customer = customer
  end

  def handle_message(message)
    @message = message
    find_responder_for_message!

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
    begin
      ActiveRecord::Base.transaction do
        @session[:cart].each do |item|
          menu = Menu.find(item['id'])
          Order.create!(menu: menu, provider: menu.provider, customer: @customer)
        end
      end
      @session[:current_step] = nil
      @session[:cart] = []
      @responder = SimpleResponder.new('Заказ оформлен! Yay!')
    rescue
      @responder = SimpleResponder.new('NOOOOOOOOOOOOOOOOOO!')
    end
  end

  def checkout_reject(*)
    @responder = SimpleResponder.new('Ладно, выбирайте дальше...')
  end

  def clean_confirm(*)
    @session[:cart] = []
    @responder = SimpleResponder.new('Корзина чиста!')
  end

  def clean_reject(*)
    @responder = SimpleResponder.new('Ладно, выбирайте дальше...')
  end

  def browse_items_add_item(data)
    @session[:cart] ||= []
    @session[:cart] << data
    @responder = SimpleResponder.new('Добавлено!')
  end

  private

  def find_responder_for_message!
    @responder = case step
    when 'browse_items'
        CollectionResponder.new(
          prompt: 'Что будем кушать?',
          collection: Menu.all,
          get_text: ->(item) {
            item.name
          },
          get_callback: ->(item) {
            {action: 'add_item', data: {id: item.id}}
          }
        )
      when 'clean'
        BooleanResponder.new(prompt: 'Удалить заказ?')
      when 'checkout'
        BooleanResponder.new(
          prompt: "Оформим заказ?\n #{serialise_cart}"
        )
      else FallbackResponder.new
    end
  end

  def serialise_cart
    return '' unless @session[:cart].present?

    sum = @session[:cart].reduce(0) do |acc, item|
      menu = Menu.find(item[:id])
      acc += menu.price
      acc
    end

    list = @session[:cart].try do |cart|
      cart.map { |i| [i['name'], i['price']].join(' - ') }
    end

    list << "Total: #{sum}"
    list.join("\n")
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
