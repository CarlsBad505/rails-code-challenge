require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe '#index' do
    subject { get :index }
    it { is_expected.to have_http_status(:ok) }
  end

  describe '#show' do
    let(:order) { Order.create! }
    subject { get :show, params: { id: order.id } }
    it { is_expected.to have_http_status(:ok) }
  end

  describe '#new' do
    subject { get :new }
    it { is_expected.to have_http_status(:ok) }
  end

  describe '#create' do
    let(:widget) { Widget.create!(msrp: 40) }
    let(:order_params) do
      {
         order: {
          shipped_at: Time.now,
          expedite: true,
          line_item: {
            widget_id: widget.id,
            quantity: 1,
            unit_price: widget.msrp
          }
        }
      }
    end

    it "creates a new order" do
      expect { post :create, params: order_params }.to change(Order, :count).by(+1)
    end
  end
end
