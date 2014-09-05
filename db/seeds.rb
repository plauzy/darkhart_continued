# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Code retrieved and modified from https://github.com/nodanaonlyzuul/against-humanity

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
  # BlackCard.create(content:question["text"]) unless question["numAnswers"]>1
  p question["text"] unless question["numAnswers"] > 1
end

answers.each do |answer|
  # WhiteCard.create(content:answer["text"])
  p answer["text"]
end
