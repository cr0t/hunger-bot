module HungerBot
  VERSION = '0.0.0'

  HELLOS = ['привет', 'добрый день', 'хай', 'хой', 'приуэт', 'йоу', 'йо']

  def self.process_text_message(input, customer)
    text = HungerBot.normalize(input)

    case text
    when *HungerBot::HELLOS
      if customer.newbie?
        "йоу! афцант готов вас обслужить! слушаю! а ты новенький? представься (напиши мне /name имя фамилия)!"
      else
        "даров, #{customer.first_name}! афцант-браза слушает! слушаю!"
      end
    else
      BOT.learn(text)
      BOT.answer(text)
    end
  end

  private

  def self.normalize(text)
    text.mb_chars.strip.downcase.to_s
  end
end
