class ManagementController < ApplicationController
  before_filter :verify_permissions
  def show
  end

  def update
    params[:settings].each do |key, value|
      # I'd like to keep settings in their true data type
      # but parameters always come in as strings. I have
      # added the fixnum? method to the string class in
      # config/initalizers/class_modifications.rb
      Setting[key] = value.fixnum? ? value.to_i : value
    end

    Setting[:save_IPs] = nil if params[:settings][:save_IPs].nil?

    redirect_to request.referer
  end
end
