module Spree
  class Gateway::Smspay < Gateway
    preference :title, :string
    preference :description, :string
    preference :merchant_user, :string
    preference :merchant_password, :string
    preference :success_url, :string, default: 'http://example.com/smspay/success'
    preference :failure_url, :string, default: 'http://example.com/smspay/failure'

    def payment_source_class
      SmspayMobileNumber
    end

    def payment_profiles_supported?
      true
    end

    def supports?(source)
      true
    end

    def create_profile(payments)
    end

    def provider
      ::SpreeSmspay::Api.new(
        description: preferred_description,
        user: preferred_merchant_user,
        password: preferred_merchant_password,
        base_url: base_url,
        success_url: preferred_success_url,
        failure_url: preferred_failure_url
      )
    end

    def base_url
      preferred_test_mode ? 'http://api.smspay.devz.no' : 'https://api.smspay.io'
    end

    def auto_capture?
      false
    end

    def method_type
      'smspay'
    end

    def authorize(amount, smspay_mobile_number, gateway_options = {})
      order_number = gateway_options[:order_id].split('-').first
      payment_idetifier = gateway_options[:order_id].split('-').last
      order = Order.where(number: order_number).first
      items = build_items(order.line_items)

      additional_adjustments = order.all_adjustments.additional
      tax_adjustments = additional_adjustments.tax
      shipping_adjustments = additional_adjustments.shipping

      additional_adjustments.eligible.each do |adjustment|
        next if tax_adjustments.include?(adjustment) || shipping_adjusmtents.include?(adjustment)

        items["item_number_#{i+1}".to_sym] = adjustment.id
        items["item_name_#{i+1}".to_sym] = adjustment.label
        items["quantity_#{i+1}".to_sym] = 1
        items["amount_#{i+1}".to_sym] = adjustment.amount.to_s
        items["shipping_#{i+1}".to_sym] = 0
      end

      smspay = provider
      smspay_checkout = SmspayCheckout.create(
        smspay_mobile_number: smspay_mobile_number,         
        order: order)

      if smspay.login
        response = smspay.payments(smspay_checkout, items)
        if response.status == 200
          smspay_checkout.reference = response.body['reference']
          smspay_checkout.status = response.body['status']
          payment = Payment.find_by(:identifier => payment_idetifier)
          payment.response_code = response.body['reference']
          # Update payment state
          case response.body['status']
          when 'NEW'
            payment.started_processing
          when 'PENDING'
            payment.pend
          when 'CANCELLED'
            payment.failure
          when 'COMPLETED'
            payment.complete
          when 'PROCESSING'
            payment.started_processing
          end

          if smspay_checkout.save && payment.save
           return Class.new do
              def success?; true; end
              def authorization; nil; end
            end.new
          end
        else
          return Class.new do
            def success?; false; end
            def authorization; nil; end
          end.new
        end
      end

      Class.new do
        def success?; false; end
        def authorization; nil; end
      end.new
    end

    private

    def build_items(line_items)
      items = {}
      line_items.each_with_index do |item, i|
        items["item_number_#{i+1}".to_sym] = item.variant.sku
        items["item_name_#{i+1}".to_sym] = item.product.name
        items["quantity_#{i+1}".to_sym] = item.quantity
        items["amount_#{i+1}".to_sym] = item.price.to_s
        items["shipping_#{i+1}".to_sym] = 0
      end
      items
    end
  end
end
