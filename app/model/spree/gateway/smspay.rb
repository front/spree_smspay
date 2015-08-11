module Spree
  class Gateway::Smspay < Gateway
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
        description: description,
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

    def payment_idetifier
      @gateway_options[:order_id].split('-').last
    end

    def authorize(amount, smspay_mobile_number, gateway_options = {})
      @smspay_mobile_number = smspay_mobile_number
      @gateway_options = gateway_options
      @provider = provider

      order_number = gateway_options[:order_id].split('-').first
      @order = Order.where(number: order_number).first
      items = build_items(@order.line_items)

      additional_adjustments = @order.all_adjustments.additional
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

      response = commit('login')

      if response.success?
        response = commit('payments', items)
      end
      response
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

    def commit(action, items = nil)
      raw_response = response = nil
      success = false
      begin
        if items
          raw_reponse = @provider.send(action.to_sym, @smspay_mobile_number.mobile_number, @order.id, items)
        else
          raw_reponse = @provider.send(action.to_sym)
        end
        response = raw_reponse
        success = (raw_reponse.status == 200)
      rescue ActiveMerchant::ResponseError => e
        raw_response = e.response.body
        response = response_error(raw_response)
      rescue JSON::ParserError
        response = json_error(raw_response.body)
      end

      card = {}
      avs_code = {}
      cvc_code = {}

      if success && action == 'payments'
        smspay_checkout = SmspayCheckout.create(
          smspay_mobile_number: @smspay_mobile_number,
          order: @order)
        smspay_checkout.reference = response.body['reference']
        smspay_checkout.status = response.body['status']
        payment = Payment.find_by(:identifier => payment_idetifier)
        payment.response_code = response.body['reference']

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
        smspay_checkout.save
        payment.save
      end
      ActiveMerchant::Billing::Response.new(
        success,
        success ? "Transaction approved" : response.body['error']['message'],
        response.body,
        :test => response.body.has_key?('livemode') ? !response.body['livemode'] : false,
        :authorization => success ? response.body['id'] : response.body['error']['charge'],
        :avs_result => { :code => avs_code },
        :cvc_result => cvc_code
      )
    end

    def response_error(raw_response)
      begin
        parse(raw_response)
      rescue JSON::ParserError
        json_error(raw_response)
      end
    end

    def json_error(raw_response)
      msg = 'Invalid response received from the SMSPay API.'
      msg += "  (The raw response returned by the API was #{raw_response.inspect})"
      {
        "error" => {
          "message" => msg
        }
      }
    end
  end
end
