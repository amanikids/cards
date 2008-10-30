class RootsController < ApplicationController
  def index
    country_code = Locator.service.country_code(request.remote_ip)
    distributor = Distributor.find_by_country_code(country_code) || Distributor.default
    redirect_to distributor_root_path(distributor)
  end
end
