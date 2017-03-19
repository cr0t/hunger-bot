class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!
  use_session!

  before_action :load_customer
  before_action :load_handler
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
end
