module Spree
  class SmspayMobileNumber < Spree::Base
    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
    has_many :payments, as: :source

    def imported
      false
    end
  end
end