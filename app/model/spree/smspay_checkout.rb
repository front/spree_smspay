# == Schema Information
#
# Table name: smspay_checkouts
#
#  id                      :integer          not null, primary key
#  reference               :integer
#  amount                  :decimal
#  status                  :string(255)
#  order_id                :integer
#  smspay_mobile_number_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

module Spree
  class SmspayCheckout < Spree::Base
    belongs_to :user
    belongs_to :order
    belongs_to :smspay_mobile_number, class_name: 'Spree::SmspayMobileNumber', foreign_key: :smspay_mobile_number_id
  end
end
