class SnipesController < ApplicationController

  before_action :authorize

  def new
    @snipe = Snipe.new
  end

end
