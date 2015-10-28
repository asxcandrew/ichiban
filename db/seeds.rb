# This file contains all default values needed to seed the database.
# The data can be loaded with the rake db:seed (or created alongside the db with db:setup).

# Remember to use the correct data type for each entry.
# => 1 != "1"
# site_settings = { site_name: 'Ichiban', site_tagline: 'Modern Imageboard' }

# site_settings.each do |key, value|
#   Setting[key] = value
# end

boards = [ 
  { name: "Video Games",
    description: "HARDCORE GAYMEN",
    directory: 'gam'},

  { name: "Technology",
    description: "Computers & Phones",
    directory: 'tech'},

  { name: "Anime",
    description: "Uguu~",
    directory: 'ani'}
]

boards.each do |board|
  Board.create!(board)
end

User.create!({ email: "admin@example.com",
               password: "password"})
