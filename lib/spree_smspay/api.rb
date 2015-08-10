require 'faraday_middleware'
module SpreeSmspay
  class Api
    attr_accessor :conn, :options, :merchant_id, :token

    def initialize(options = {})
      @options = options
      @conn = connection
    end

    def connection
      ::Faraday.new(url: options[:base_url]) do |conn|
        conn.request :url_encoded
        conn.response :logger
        conn.response :json, :content_type => /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def login
      response = @conn.post do |req|
        req.url '/v1/login'
        req.body = {
          user: options[:user],
          password: options[:password]
        }
      end
      if response.status == 200 && response.body.present?
        @merchant_id = response.body['merchantId']
        @token = "Bearer #{response.body['token']}"
      end
      response
    end

    def payments(mobile_number, order_id, items)
      body = {
        :phone => mobile_number,
        :invoice => "#{order_id}",
        :currency => "NOK",
        :merchant => @merchant_id,
        :description => options[:description],
        :shipping => 0,
        :success_url => options[:success_url],
        :failure_url => options[:failure_url]
      }
      body = body.merge(items)
      payment = @conn.post do |req|
        req.url '/v1/payments'
        req.headers['Authorization'] = @token
        req.body = body
      end
      payment
    end
  end
end