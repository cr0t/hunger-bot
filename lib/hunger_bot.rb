module HungerBot
  VERSION = '0.0.0'

  def self.normalize(text)
    text.mb_chars.strip.downcase.to_s
  end
end
