require 'spec_helper'

describe Spree::Gateway::Smspay do
  let(:gateway) { Spree::Gateway::Smspay.create!(:name => "Smspay", :environment => Rails.env) }

  context "payment purchase" do
    let(:payment) do
      payment = FactoryGirl.create(:payment, :payment_method => gateway, :amount => 10)
      mobile_number = FactoryGirl.create(:smspay_mobile_number)
      allow(payment).to receive(:source).and_return(mobile_number)
      payment
    end

    let(:provider) do
      provider = double('Provider')
      allow(gateway).to receive(:provider).and_return(provider)
      provider
    end

    before do
      expect(provider).to receive(:login).and_return(true)
    end

    it "succeeds" do
      expect(provider).to receive(:payments).and_return(true)
      expect{ payment.purchase! }.to_not raise_error
    end
  end
end