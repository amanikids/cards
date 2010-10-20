class ShamPayPalAPI < Sinatra::Base
  post '/2.0/' do
    handle Nokogiri::XML(request.body)
  end

  not_found do
    abort "Unhandled request: #{request.request_method} #{request.path}"
  end

  def handle(xml)
    dispatch xml.xpath('/env:Envelope/env:Body/*/*').first
  end

  def dispatch(xml)
    if respond_to?(method_name = xml.name.underscore)
      send method_name, xml
    else
      abort "Method #{method_name} is not defined."
    end
  end

  def set_express_checkout_request(xml)
    return <<-XML
      <SetExpressCheckoutResponse>
        <ACK>Success</ACK>
        <TOKEN>42</TOKEN>
      </SetExpressCheckoutResponse>
    XML
  end
end

class ShamPayPalUI < Sinatra::Base
  not_found do
    abort "Unhandled request: #{request.request_method} #{request.path}"
  end
end
