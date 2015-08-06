module Spree
  class SmspayController < StoreController
    def success
      if params[:status].blank? || params[:reference].blank? || params[:invoice].blank?
        render json: "Reference, Status and Invoice fields must be present", status: 400
      else
        id = params[:invoice].to_i
        checkout = SmspayCheckout.where(id: id, reference: params[:reference]).first
        checkout.status = params[:status]
        if checkout.save
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
        if checkout.save
          render text: "ACCEPTED"
        else
          render json: checkout.errors, status: 422
        end
      end
    end
  end
end