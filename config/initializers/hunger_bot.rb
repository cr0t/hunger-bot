require 'markov_chain_chat_bot'

FILENAME = 'southpark.txt'

if File.exists? FILENAME
  BOT = MarkovChainChatBot.from(Hash.new)
  File.open(FILENAME, 'r').each do |line|
    BOT.learn(line)
  end
  puts 'Bot graduated successfully.'
end
