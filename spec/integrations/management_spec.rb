require 'spec_helper'
include BoardSupport

describe "The management panel", js: true do
  
  it "allows me to create a board." do
    create_board
  end

  it "will not make duplicate boards" do
    create_board
    page.current_path.should == boards_path
    page.should have_no_css('.flash error')

    # Second attempt
    create_board
    within('.flash') do
      page.should have_content "Directory has already been taken"
    end
  end
end