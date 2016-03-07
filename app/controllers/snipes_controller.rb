class SnipesController < ApplicationController

  before_action :authorize

  def index
    @snipes = current_user.snipes.includes(:ebay_item)
  end

  def new
    @snipe = Snipe.new
  end

  def edit
    @snipe = Snipe.find(params[:id])
  end

  def update
    @snipe = Snipe.find(params[:id])
    if @snipe.update_attributes(snipe_params)
      redirect_to snipes_path, notice: 'updated'
    else
      render :edit
    end
  end

  def destroy
    @snipe = Snipe.find(params[:id])
    @snipe.destroy
    redirect_to snipes_path, notice: 'removed'
  end

private

  def snipe_params
    params.require(:snipe).permit(:max_amount)
  end

end
