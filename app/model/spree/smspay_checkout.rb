# == Schema Information
#
# Table name: smspay_transactions
#
#  id                :integer          not null, primary key
#  phone_code        :integer
#  phone_numebr      :integer
#  mobile_number     :string
#  reference         :integer
#  amount            :integer
#  status            :string(255)
#  order_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Spree
  class SmspayCheckout < Spree::Base
    belongs_to :user
    belongs_to :order
    belongs_to :smspay_mobile_number
  end
end
