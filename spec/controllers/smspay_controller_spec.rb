require 'spec_helper'

describe Spree::SmspayController do
  let(:payment) { FactoryGirl.create(:payment, response_code: '12345678') }
  let(:order) { FactoryGirl.create(:order) }

  before do
    allow(controller).to receive(:current_order).and_return(nil)
    allow(controller).to receive(:current_spree_user).and_return(nil)
  end

  describe '#success' do
    before do
      FactoryGirl.create(
        :smspay_checkout,
        order: order,
        reference: payment.response_code
      )
    end

    it 'success' do
      params = {
        use_route: :spree,
        status: "COMPLETED",
        reference: payment.response_code,
        invoice: order.id
      }
      post :success, params
      expect(response.body).to eq 'ACCEPTED'
    end
  end

  describe '#failure' do
    before do
      FactoryGirl.create(
        :smspay_checkout,
        order: order,
        reference: payment.response_code
      )
    end

    it 'success' do
      params = {
        use_route: :spree,
        status: "COMPLETED",
        reference: payment.response_code,
        invoice: order.id
      }
      post :failure, params
      expect(response.body).to eq 'ACCEPTED'
    end
  end

end