class RootsController < ApplicationController
  def index
    all_distributors = Distributor.all

    distributor = Distributor.find_by_country_code(country_code) || Distributor.default

    flash[:notice] = "<h2>Welcome!</h2><p>We think our <strong>#{distributor.country}</strong> distributor is closest to you, but we may have guessed wrong!<br />Please select our #{distributor.others.map { |d| @template.link_to d.country, distributor_root_path(d) }.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')} distributor if so.</p>"
    redirect_to distributor_root_path(distributor)
  end

  protected

  def country_code
    result = GeoIP.new(Rails.root.join('db', 'geo_ip.dat')).country(request.remote_ip)
    code = result ? result[3] : 'GB'
    code = 'uk' if code == 'GB'
    code.downcase
  end
end
