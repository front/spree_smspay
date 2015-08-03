module Spree
  class SmspayController < StoreController
    def confirm
      order = current_order || raise(ActiveRecord::RecordNotFound)

      begin
        if provider.login
          order.payments.create!(
            source: SmspayCheckout.create(
              phone_code: params[:phone_code],
              phone_number: params[:phone_number],
              order: order),
            amount: order.total,
            payment_method: payment_method
          )
          order.next
          if order.complete?
            flash.notice = Spree.t(:order_processed_successfully)
            flash[:order_completed] = true
            session[:order_id] = nil
            redirect_to completion_route(order)
          else
            redirect_to checkout_state_path(order.state)
          end
        else
          flash[:error] = Spree.t('flash.generic_error', scope: 'smspay', reasons: "Unauthorized")
          redirect_to checkout_state_path(order.state)
        end
      rescue SocketError
        flash[:error] = Spree.t('flash.connection_failed', scope: 'smspay')
        redirect_to checkout_state_path(:payment)
      end
    end

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

    private

    def payment_method
      Spree::PaymentMethod.find(params[:payment_method_id])
    end

    def provider
      payment_method.provider
    end

    def build_item(line_items)
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

    def completion_route(order)
      order_path(order)
    end

  end
end