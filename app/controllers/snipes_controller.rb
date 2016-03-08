class SnipesController < ApplicationController

  before_action :authorize

  def index
    @snipes = current_user.snipes.upcoming
  end

  def new
    @snipe = Snipe.new
  end

  def edit
    @snipe = Snipe.find(params[:id])
  end

  def create
    if @snipe = current_user.make_snipe(snipe_params[:ebay_item_id], snipe_params[:max_amount])
      redirect_to snipes_path, notice: 'created'
    else
      render :new
    end
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
    params.require(:snipe).permit(:max_amount, :ebay_item_id)
  end

end
