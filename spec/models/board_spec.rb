require File.dirname(__FILE__) + "/../spec_helper.rb"

describe Board do
  let(:attributes) do
    { name: "Test Board", 
      directory: 'test', 
      description: "A test"}
  end
  
  it 'should create a new instance with valid attributes' do
    Board.create!(attributes)
  end

  it 'should require a name' do
    no_name_board = Board.new(attributes.merge(name: ''))
    no_name_board.should be_invalid
  end

  it 'should require a directory' do
    no_directory_board = Board.new(attributes.merge(directory: ''))
    no_directory_board.should be_invalid
  end
end