require 'json'

cards = JSON.parse(File.read("./db/third_party/cards.json"))

questions, answers = cards.partition{ |card| card["cardType"] == "Q"}

# File.open("questions.txt", "w") do |f|
#   questions.reject!{ |card| card["numAnswers"]>1 }
#   questions.each do |question|
#     f << "#{question["text"]}\n"
#   end
# end

# File.open("answers.txt", "w") do |f|
#   answers.each do |answer|
#     f << "#{answer["text"]}\n"
#   end
# end

questions.each do |question|
  Blackcard.create(content:question["text"]) unless question["numAnswers"]>1
  p question["text"] unless question["numAnswers"] > 1
end

answers.each do |answer|
  Whitecard.create(content:answer["text"])
  p answer["text"]
end
