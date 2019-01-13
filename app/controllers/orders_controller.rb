class OrdersController < ApplicationController
  def index
    @orders_shipped = Order.where.not(shipped_at: nil).order(:shipped_at)
    @orders_not_shipped = Order.where(shipped_at: nil)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @widgets = Widget.order(:name)
    @order.line_items.build
  end

  def create
    @widgets = Widget.all
    @order = Order.create(order_params)
    if @order.save
      redirect_to order_path(@order)
    else
      render 'new'
    end
  end

  private

  def order_params
    params.require(:order).permit(:shipped_at, :expedite, line_items_attributes: [:id, :quantity, :unit_price, :widget_id])
  end
end
