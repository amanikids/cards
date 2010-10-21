class ShamPayPal < Sinatra::Base
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

  # Web UI Methods ----------------------------------------------------
  # TODO perhaps express checkout shouldn't redirect immediately; perhaps we
  # should have to push a button instead?
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
              <Name>Bob Loblaw</Name>
              <Street1>123 Main St.</Street1>
              <Street2></Street2>
              <CityName>Anytown</CityName>
              <StateOrProvince>AB</StateOrProvince>
              <Country>US</Country>
              <PostalCode>12345</PostalCode>
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
