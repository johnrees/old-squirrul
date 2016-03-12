class Admin::AdminController < ApplicationController
  layout 'admin'

  before_action :check_if_admin

private

  def check_if_admin
    redirect_to root_url unless current_user and current_user.username == ENV.fetch('ebay_user')
  end

end
