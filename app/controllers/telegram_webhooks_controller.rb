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

  def memo(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: t('.notice')
    else
      respond_with :message, text: t('.prompt')
      save_context :memo
    end
    logger.info "session[:memo]: #{session[:memo]}"
  end

  def remind_me
    logger.info "remind_me#session[:memo]: #{session[:memo]}"
    to_remind = session.delete(:memo)
    reply = to_remind || t('.nothing')
    respond_with :message, text: reply
  end

  def message(message)
    if message['text'].present?
      respond_with :message, text: HungerBot.process_text_message(message['text'])
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
    # binding.pry
  end
end
