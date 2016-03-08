class SnipesController < ApplicationController

  before_action :authorize

  def index
    @snipes = current_user.snipes.upcoming.includes(:ebay_item)
    @snipe = Snipe.new
  end

  def new
    @snipe = Snipe.new
  end

  def edit
    @snipe = Snipe.find(params[:id])
  end

  def create
    @snipe = current_user.snipes.build(snipe_params)
    if @snipe.save
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

  def force_bid
    @snipe = Snipe.find(params[:id])
    @snipe.bid!
    redirect_to snipes_path, notice: 'bid placed'
  end

private

  def snipe_params
    params.require(:snipe).permit(:max_amount, :ebay_item_input)
  end

end
