class OrdersController < ApplicationController
  def index
    @orders_shipped = Order.where.not(shipped_at: nil).order(:shipped_at)
    @orders_not_shipped = Order.where(shipped_at: nil)
  end

  def show
    @order = Order.find(params[:id])
  end
end
