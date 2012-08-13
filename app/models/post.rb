class Post < ActiveRecord::Base
  attr_accessible :name, :subject, :body, :tripcode, :directory, :parent_id

  belongs_to :board
  belongs_to :parent, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id

  before_save :parse_name, :render_markdown

  def to_params
    binding.pry
  end

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  def parse_name
    input = self.name
    hash_pos = input.index('#')

    if hash_pos
      name = hash_pos == 0 ? 'Anonymous' : input[0...hash_pos]
      
      # Everything after the hash.
      password = input[ ((hash_pos + 1)..-1) ]

      self.tripcode = crypt_tripcode(password)
      self.name = name
    else
      self.name = input.empty? ? "Anonymous" : input
    end
  end

  def render_markdown
    self.body = $markdown.render(self.body)
  end

  def crypt_tripcode(input)
    # Below is the canonical way to make 2ch style tripcodes.
    # I'm not sure who thought this was a good idea.
    forbidden_in_salt = ':;<=>?@[\]^_`'
    forbidden_in_alternative = 'ABCDEFGabcdef'
    
    # Take second and third characters from input and appends 'H.'
    salt = (input + 'H.')[1..2]
    
    # Replace any characters not between . and z with .
    salt.gsub!(/[^a-zA-Z0-9\.]/, '.')
    
    # Replace any of the characters in :;<=>?@[\]^_` 
    # with the corresponding character from ABCDEFGabcdef.
    salt.tr!(forbidden_in_salt, forbidden_in_alternative)

    # Call crypt and returns the last 10 characters.
    input.crypt(salt)[-10..-1]
  end
end