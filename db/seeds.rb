# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create!({ name: "Administrator" })
Role.create!({ name: "Moderator" })
Role.create!({ name: "Janitor" })

Operator.create!({ email: "admin@example.com",
                   password: "password",
                   role_id: 1 })

boards = [ 
  { name: "Video Games",
    description: "Vidya",
    directory: 'gaming'},

  { name: "Technology",
    description: "Computers & Phones",
    directory: 'technology'},

  { name: "Anime",
    description: "Uguu~",
    directory: 'anime'},

  { name: "Test",
    description: "Testing. 1, 2, 3.",
    directory: 'test'},
]

boards.each do |board|
  Board.create!(board)
end

