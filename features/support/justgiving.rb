class ShamJustgiving < Sinatra::Base
  get '/donation/direct/charity/:identifier' do
    redirect params[:exitUrl].sub('JUSTGIVING-DONATION-ID', '42')
  end

  not_found do
    abort "404: #{request.request_method} #{request.path}"
  end

  error do
    abort env['sinatra.error'].message
  end
end
