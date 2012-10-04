# This file contains all default values needed to seed the database.
# The data can be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create!({ email: "admin@example.com",
               password: "password",
               :role => :admin,
               role: :admin })

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

