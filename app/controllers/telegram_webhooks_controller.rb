class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!
  use_session!

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
    logger.info '---'
    logger.info HungerBot.normalize(message['text'])
    logger.info '---'

    case HungerBot.normalize(message['text'])
    when 'привет'
      text = 'йоу! афцант готов вас обслужить! слушаю!'
    else
      text = "You wrote: #{text}"
    end

    respond_with :message, text: text
  end
end
