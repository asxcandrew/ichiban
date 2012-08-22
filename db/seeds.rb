# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Operator.create!({ email: "admin@example.com",
                   password: "password"})

boards = [ 
  { name: "Video Games",
    description: "Vidya",
    directory: 'v'},

  { name: "Technology",
    description: "Computers & Phones",
    directory: 'g'},

  { name: "Anime",
    description: "Uguu~",
    directory: 'a'},

  { name: "Test",
    description: "Testing. 1, 2, 3.",
    directory: 'test'},
]

boards.each do |board|
  Board.create!(board)
end

