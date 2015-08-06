module Spree
  class SmspayController < StoreController
    def success
      if params[:status].blank? || params[:reference].blank? || params[:invoice].blank?
        render json: "Reference, Status and Invoice fields must be present", status: 400
      else
        id = params[:invoice].to_i
        checkout = SmspayCheckout.where(id: id, reference: params[:reference]).first
        checkout.status = params[:status]

        if checkout.save && update_payment_state(params[:reference])
          render text: "ACCEPTED"
        else
          render json: checkout.errors, status: 422
        end
      end
    end

    def failure
      if params[:status].blank? || params[:reference].blank? || params[:invoice].blank?
        render json: "Reference, Status and Invoice fields must be present", status: 400
      else
        id = params[:invoice].to_i
        checkout = SmspayCheckout.where(id: id, reference: params[:reference]).first
        checkout.status = params[:status]

        if checkout.save && update_payment_state(params[:reference])
          render text: "ACCEPTED"
        else
          render json: checkout.errors, status: 422
        end
      end
    end

    private

    def update_payment_state(response_code)
      payment = Payment.find_by(:response_code => response_code)

      # Update payment state
      case params[:status]
      when 'NEW'
        payment.started_processing
      when 'PENDING'
        payment.pend
      when 'CANCELLED'
        payment.failure
      when 'COMPLETE'
        payment.complete
      when 'PROCESSING'
        payment.started_processing
      end

      payment.save
    end
  end
end