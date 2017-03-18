module HungerBot
  VERSION = '0.0.0'

  HELLOS = ['привет', 'добрый день', 'хай', 'хой', 'приуэт', 'йоу', 'йо']

  def self.process_text_message(input)
    text = HungerBot.normalize(input)

    case text
    when *HungerBot::HELLOS
      'йоу! афцант готов вас обслужить! слушаю!'
    else
      "You wrote: #{text}"
    end
  end

  private

  def self.normalize(text)
    text.mb_chars.strip.downcase.to_s
  end
end
