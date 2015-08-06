# == Schema Information
#
# Table name: smspay_mobile_numbers
#
#  id                :integer          not null, primary key
#  code              :string
#  number            :string
#  user_id           :integer
#  default           :boolean          default: false
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Spree
  class SmspayMobileNumber < Spree::Base
    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
    has_many :payments, as: :source

    def imported
      false
    end

    def mobile_number
      "#{code}#{number}"
    end
  end
end