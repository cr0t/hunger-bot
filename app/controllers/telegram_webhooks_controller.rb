class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!
  use_session!

  before_action :load_customer
  before_action :load_handler
  before_action :track_event
  after_action :inspect_session

  def start(*)
    respond_with :message, text: t('.content')
  end

  def help(*)
    respond_with :message, text: t('.content')
  end

  def message(message)
    @handler.handle_message(message)
    respond_with(:message, @handler.response) if @handler.should_handle?
  end

  def callback_query(callback_query)
    @handler.handle_callback(callback_query)
    respond_with(:message, @handler.response)
  end

  def name(*args)
    first_name, last_name = args.split(/\s/).first.map { |s| s.strip }
    @customer.update_attributes(first_name: first_name, last_name: last_name)
    respond_with :message, text: "Будем знакомы, #{first_name} #{last_name}! я тебя запомнил!"
  end

  def message(message)
    if message['text'].present?
      respond_with :message, text: HungerBot.process_text_message(message['text'], @customer)
    else
      logger.info '---message[text] is nil'
      logger.info message.inspect
      logger.info '---'
    end
  end

  private

  def load_customer
    from_id = payload['from']['id']
    @customer = Customer.find_or_create_by(telegram_id: from_id)
  end

  def load_handler
    @handler ||= BaseHandler.new(session, @customer)
  end

  def inspect_session
    Rails::logger.info session.inspect
  end

  def track_event
    from_id = payload['from']['id'].to_i
    @customer.telegram_messages.build(
      raw: payload,
      telegram_from_id: from_id,
      body: payload['text']
    ).save!
  end
end
