module Spree
  class SmspayController < StoreController
    protect_from_forgery with: :null_session

    def success
      if params[:status].blank? || params[:reference].blank? || params[:invoice].blank?
        render json: "Reference, Status and Invoice fields must be present", status: 400
      else
        checkout = SmspayCheckout.where(
          order_id: params[:invoice].to_i,
          reference: params[:reference]
        ).first

        if checkout
          checkout.status = params[:status]
          if checkout.save && update_payment_state(params[:reference], params[:status])
            return render text: "ACCEPTED"
          end
        end
        render json: checkout.errors, status: 422
      end
    end

    def failure
      if params[:status].blank? || params[:reference].blank? || params[:invoice].blank?
        render json: "Reference, Status and Invoice fields must be present", status: 400
      else
        checkout = SmspayCheckout.where(
          order_id: params[:invoice].to_i,
          reference: params[:reference]
        ).first

        if checkout
          checkout.status = params[:status]
          if checkout.save && update_payment_state(params[:reference], params[:status])
            return render text: "ACCEPTED"
          end
        end
        render json: checkout.errors, status: 422
      end
    end

    private

    def update_payment_state(response_code, status)
      payment = Payment.find_by(:response_code => response_code)

      # Update payment state
      case status
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

      payment.save
    end
  end
end