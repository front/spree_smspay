module Spree
  CheckoutController.class_eval do
    before_action :permit_smspay_attributes, only: [:update]

    private

    def permit_smspay_attributes
      [:code, :number].each do |attr|
        unless permitted_source_attributes.include?(attr)
          permitted_source_attributes << attr
        end
      end
    end
  end
end