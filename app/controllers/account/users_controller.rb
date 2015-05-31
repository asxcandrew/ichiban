class Account::UsersController < ApplicationController
	def show
		redirect_to account_user_boards_path current_user
	end
end
