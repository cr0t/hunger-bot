class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!
  use_session!

  before_action :load_customer

  def start(*)
    respond_with :message, text: t('.content')
  end

  def help(*)
    respond_with :message, text: t('.content')
  end

  def message(message)
    respond_with :message, responder_for(message).response
  end

  def callback_query(data)
    answer_callback_query "Оки доки, #{data}"
  end

  private

  def load_customer
    from_id = payload['from']['id']
    @customer = Customer.find_or_create_by(telegram_id: from_id)
  end

  def responder_for(message)
    @resolver ||= BaseResponder.responder_for(message['text'])
  end
end
