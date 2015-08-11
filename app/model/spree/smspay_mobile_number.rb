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
  class SmspayMobileNumber < ActiveRecord::Base

    attr_accessible :code, :number, :user_id, :default

    validates :code, :presence => true
    validates :number, :presence => true
    validate  :mobile_number_must_have_valid_length

    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
    has_many :payments, as: :source

    def imported
      false
    end

    def mobile_number
      "#{code}#{number}"
    end

    def mobile_number_must_have_valid_length
      if number.present? && mobile_number.to_i < 1000000000
        errors.add(:number, :invalid_mobile_number)
      end
    end
  end
end