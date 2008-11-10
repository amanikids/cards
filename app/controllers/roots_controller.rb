class RootsController < ApplicationController
  def index
    all_distributors = Distributor.ordered
    country_code = Locator.country_code(request.remote_ip)
    distributor = Distributor.find_by_country_code(country_code) || Distributor.default

    flash[:notice] = "<h2>Welcome!</h2><p>We think our <strong>#{distributor.country}</strong> distributor is closest to you, but we may have guessed wrong!<br />Please select our #{(Distributor.ordered - [distributor]).map { |d| @template.link_to d.country, distributor_root_path(d) }.to_sentence(:connector => 'or')} distributors if so.</p>"
    redirect_to distributor_root_path(distributor)
  end
end
