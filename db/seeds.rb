# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!({ email: "admin@example.com",
                   password: "password",
                   :role => :admin })

# Remember to use the correct data type for each entry.
# => 1 != "1"
site_settings = { site_name: 'Ichiban!',
                  max_reports_per_IP: 6 }

site_settings.each do |key, value|
  Setting[key] = value
end

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

