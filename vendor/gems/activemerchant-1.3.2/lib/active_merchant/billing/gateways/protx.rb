module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class ProtxGateway < Gateway  
      cattr_accessor :simulate
      self.simulate = false
      
      TEST_URL = 'https://ukvpstest.protx.com/vspgateway/service'
      LIVE_URL = 'https://ukvps.protx.com/vspgateway/service'
      SIMULATOR_URL = 'https://ukvpstest.protx.com/VSPSimulator'
    
      APPROVED = 'OK'
    
      TRANSACTIONS = {
        :purchase => 'PAYMENT',
        :credit => 'REFUND',
        :authorization => 'DEFERRED',
        :capture => 'RELEASE',
        :void => 'VOID'
      }
      
      CREDIT_CARDS = {
        :visa => "VISA",
        :master => "MC",
        :delta => "DELTA",
        :solo => "SOLO",
        :maestro => "MAESTRO",
        :american_express => "AMEX",
        :electron => "UKE",
        :diners_club => "DC",
        :jcb => "JCB"
      }
      
      ELECTRON = /^(424519|42496[23]|450875|48440[6-8]|4844[1-5][1-5]|4917[3-5][0-9]|491880)\d{10}(\d{3})?$/
      
      AVS_CVV_CODE = {
        "NOTPROVIDED" => nil, 
        "NOTCHECKED" => 'X',
        "MATCHED" => 'Y',
        "NOTMATCHED" => 'N'
      }
    
      self.supported_cardtypes = [:visa, :master, :american_express, :discover, :jcb, :solo, :maestro, :diners_club]
      self.supported_countries = ['GB']
      self.default_currency = 'GBP'
      
      self.homepage_url = 'http://www.protx.com'
      self.display_name = 'Protx'

      def initialize(options = {})
        requires!(options, :login)
        @options = options
        super
      end
      
      def test?
        @options[:test] || Base.gateway_mode == :test
      end
      
      def purchase(money, credit_card, options = {})
        requires!(options, :order_id)
        
        post = {}
        
        add_amount(post, money, options)
        add_invoice(post, options)
        add_credit_card(post, credit_card)
        add_address(post, options)
        add_customer_data(post, options)

        commit(:purchase, post)
      end
      
      def authorize(money, credit_card, options = {})
        requires!(options, :order_id)
        
        post = {}
        
        add_amount(post, money, options)
        add_invoice(post, options)
        add_credit_card(post, credit_card)
        add_address(post, options)
        add_customer_data(post, options)

        commit(:authorization, post)
      end
      
      # Only supports capturing the original amount of the transaction
      def capture(money, identification, options = {})
        post = {}
        
        add_reference(post, identification)
        commit(:capture, post)
      end
      
      def void(identification, options = {})
        post = {}
        
        add_reference(post, identification)
        commit(:void, post)
      end
      
      # Crediting requires a new order_id to passed in, as well as a description
      def credit(money, identification, options = {})
        requires!(options, :order_id, :description)
        
        post = {}
        
        add_credit_reference(post, identification)
        add_amount(post, money, options)
        add_invoice(post, options)
        
        commit(:credit, post)
      end
      
      private
      def add_reference(post, identification)
        order_id, transaction_id, authorization, security_key = identification.split(';') 
        
        add_pair(post, :VendorTxCode, order_id)
        add_pair(post, :VPSTxId, transaction_id)
        add_pair(post, :TxAuthNo, authorization)
        add_pair(post, :SecurityKey, security_key)
      end
      
      def add_credit_reference(post, identification)
        order_id, transaction_id, authorization, security_key = identification.split(';') 
        
        add_pair(post, :RelatedVendorTxCode, order_id)
        add_pair(post, :RelatedVPSTxId, transaction_id)
        add_pair(post, :RelatedTxAuthNo, authorization)
        add_pair(post, :RelatedSecurityKey, security_key)
      end
      
      def add_amount(post, money, options)
        add_pair(post, :Amount, amount(money), :required => true)
        add_pair(post, :Currency, options[:currency] || currency(money), :required => true)
      end

      def add_customer_data(post, options)
        add_pair(post, :BillingEmail, options[:email])
        add_pair(post, :ContactNumber, options[:phone])
        add_pair(post, :ContactFax, options[:fax])
        add_pair(post, :ClientIPAddress, options[:ip])
      end

      def add_address(post, options)
        address = options[:billing_address] || options[:address]
        shipping_address = options[:shipping_address] || ''
        
        return if address.blank?

        billing = "#{address[:address1]}\n#{address[:address2]}\n#{address[:city]}\n#{address[:state]}"

        add_pair(post, :BillingAddress, billing)
        add_pair(post, :BillingPostcode, address[:zip])

        return if shipping_address.blank?

        shipping = "#{shipping_address[:address1]}\n#{shipping_address[:address2]}\n#{shipping_address[:city]}\n#{shipping_address[:state]}"

        add_pair(post, :DeliveryAddress, shipping)
        add_pair(post, :DeliveryPostcode, shipping_address[:zip])
      end

      def add_invoice(post, options)
        add_pair(post, :VendorTxCode, sanitize_order_id(options[:order_id]), :required => true)
        add_pair(post, :Description, options[:description] || options[:order_id])
      end

      def add_credit_card(post, credit_card)
        add_pair(post, :CardHolder, credit_card.name, :required => true)
        add_pair(post, :CardNumber, credit_card.number, :required => true)
         
        add_pair(post, :ExpiryDate, format_expiry_date(credit_card), :required => true)
         
        if requires_start_date_or_issue_number?(credit_card)
          add_pair(post, :StartDate, format(credit_card.start_year, :four_digits))
          
          add_pair(post, :IssueNumber, format_issue_number(credit_card))
        end
        add_pair(post, :CardType, map_card_type(credit_card))
        
        add_pair(post, :CV2, credit_card.verification_value)
      end
      
      def sanitize_order_id(order_id)
        order_id.to_s.gsub(/[^-a-zA-Z0-9._]/, '')
      end
      
      def map_card_type(credit_card)
        raise ArgumentError, "The credit card type must be provided" if card_brand(credit_card).blank?
        
        card_type = card_brand(credit_card).to_sym
        
        # Check if it is an electron card
        if card_type == :visa && credit_card.number =~ ELECTRON 
          CREDIT_CARDS[:electron]
        else  
          CREDIT_CARDS[card_type]
        end
      end
      
      # MMYY format
      def format_expiry_date(credit_card)
        year  = sprintf("%.4i", credit_card.year)
        month = sprintf("%.2i", credit_card.month)

        "#{month}#{year[-2..-1]}"
      end
      
      def format_issue_number(credit_card)
        card_brand(credit_card).to_s == 'solo' ? format(credit_card.issue_number, :two_digits) : credit_card.issue_number
      end

      def commit(action, parameters)
        response = parse( ssl_post(url_for(action), post_data(action, parameters)) )
          
        Response.new(response["Status"] == APPROVED, message_from(response), response,
          :test => test?,
          :authorization => authorization_from(response, parameters),
          :avs_result => { 
            :street_match => AVS_CVV_CODE[ response["AddressResult"] ],
            :postal_match => AVS_CVV_CODE[ response["PostCodeResult"] ],
          },
          :cvv_result => AVS_CVV_CODE[ response["CV2Result"] ]
        )
      end
      
      def authorization_from(response, params)
         [ params[:VendorTxCode],
           response["VPSTxId"],
           response["TxAuthNo"],
           response["SecurityKey"] ].compact.join(";")
      end
      
      def url_for(action)
        simulate ? build_simulator_url(action) : build_url(action)
      end
      
      def build_url(action)
        endpoint = [ :purchase, :authorization ].include?(action) ? "vspdirect-register" : TRANSACTIONS[action].downcase
        "#{test? ? TEST_URL : LIVE_URL}/#{endpoint}.vsp"
      end
      
      def build_simulator_url(action)
        endpoint = [ :purchase, :authorization ].include?(action) ? "VSPDirectGateway.asp" : "VSPServerGateway.asp?Service=Vendor#{TRANSACTIONS[action].capitalize}Tx"
        "#{SIMULATOR_URL}/#{endpoint}"
      end

      def message_from(response)
        if response["Status"] == APPROVED
          return 'Success'
        else
          return 'Unspecified error' if response["StatusDetail"].blank?
          return response["StatusDetail"]
        end
      end

      def post_data(action, parameters = {})
        parameters.update(
          :Vendor => @options[:login],
          :TxType => TRANSACTIONS[action],
          :VPSProtocol => "2.22"
        )
        
        parameters.collect { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
      end
      
      # Protx returns data in the following format
      # Key1=value1
      # Key2=value2
      def parse(body)
        result = {}
        body.to_a.collect {|v| c=v.split('='); result[c[0]] = c[1].chomp if !c[1].blank? }
        result
      end

      def add_pair(post, key, value, options = {})
        post[key] = value if !value.blank? || options[:required]
      end
    end
  end
end

