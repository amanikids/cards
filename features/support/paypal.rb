class ShamPaypal < Sinatra::Base
  get '/cgi-bin/webscr' do
    send params[:cmd].underscore, params
  end

  post '/2.0/' do
    xml = Nokogiri::XML(request.body)
    xml = xml.xpath('/env:Envelope/env:Body/*/*').first
    send xml.name.underscore, xml
  end

  not_found do
    abort "404: #{request.request_method} #{request.path}"
  end

  error do
    abort env['sinatra.error'].message
  end

  # Setup Methods -----------------------------------------------------
  class << self
    attr_accessor :shipping_address
  end

  # Web UI Methods ----------------------------------------------------
  def _express_checkout(params)
    redirect @@xml_request['ReturnURL'] + '?token=42&PayerID=1234567890'
  end

  # API Methods -------------------------------------------------------
  def set_express_checkout_request(xml)
    capture_xml_request(xml)

    return <<-XML
      <SetExpressCheckoutResponse>
        <Ack>Success</Ack>
        <SetExpressCheckoutResponseDetails>
          <Token>42</Token>
        </SetExpressCheckoutResponseDetails>
      </SetExpressCheckoutResponse>
    XML
  end

  def get_express_checkout_details_request(xml)
    shipping_address_xml = self.class.shipping_address.map { |field, value|
      "<#{field}>#{value}</#{field}>"
    }.join

    return <<-XML
      <GetExpressCheckoutDetailsResponse>
        <Ack>Success</Ack>
        <GetExpressCheckoutDetailsResponseDetails>
          <Token>42</Token>
          <PayerInfo>
            <Payer>bob@example.com</Payer>
            <PayerID>1234567890</PayerID>
          </PayerInfo>
          <PaymentDetails>
            <ShipToAddress>
              #{shipping_address_xml}
            </ShipToAddress>
          </PaymentDetails>
        </GetExpressCheckoutDetailsResponseDetails>
      </GetExpressCheckoutDetailsResponse>
    XML
  end

  def do_express_checkout_payment_request(xml)
    return <<-XML
      <DoExpressCheckoutPaymentResponse>
        <Ack>Success</Ack>
        <DoExpressCheckoutPaymentResponseDetails>
          <Token>42</Token>
        </DoExpressCheckoutPaymentResponseDetails>
      </DoExpressCheckoutPaymentResponse>
    XML
  end

  private

  # TODO work this into the class attr_accessor scheme.
  def capture_xml_request(xml)
    @@xml_request ||= {}
    xml.elements.each do |element|
      if element.elements.any?
        capture_xml_request(element)
      else
        @@xml_request[element.name] = element.text
      end
    end
  end
end
