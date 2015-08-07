FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_smspay/factories'

  factory :smspay_mobile_number, class: Spree::SmspayMobileNumber do
      code "45"
      number "12345678910"
      association(:user, factory: :user)
      default false
  end

  factory :smspay_checkout, class: Spree::SmspayCheckout do
    reference "12345678"
    amount "20"
    status "NEW"
    order
    smspay_mobile_number
  end
end
