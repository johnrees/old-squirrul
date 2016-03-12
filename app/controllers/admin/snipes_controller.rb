class Admin::SnipesController < Admin::AdminController
  def index
    @snipes = Snipe.includes(:user, :ebay_item)
  end
end
