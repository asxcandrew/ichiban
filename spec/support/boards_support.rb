module BoardSupport
  def create_board(options = { name: "Test Board",
                               description: "The test board.",
                               directory: "test" })
    visit new_board_path
    fill_in 'board_name', with: options[:name]
    fill_in 'board_description', with: options[:description]
    fill_in 'board_directory', with: options[:directory]
    click_button "Submit"
  end
end