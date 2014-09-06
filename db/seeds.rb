# Code retrieved and modified from https://github.com/nodanaonlyzuul/against-humanity

require 'json'

cards = JSON.parse(File.read("./db/third_party/cards.json"))

questions, answers = cards.partition{ |card| card["cardType"] == "Q"}

questions.each do |question|
  Blackcard.create(content:question["text"].gsub('_','__________')) unless question["numAnswers"]>1
end

answers.each do |answer|
  Whitecard.create(content:answer["text"])
end
