module ApplicationHelper
  def cycle_letter_classes(string, *classes)
    string.split(//).map do |c|
      c.blank? ? c : content_tag(:span, c, :class => cycle(*classes))
    end.join
  end

  def link_to_country_code(text, country_code)
    current_country_code = current_distributor ? current_distributor.country_code : nil
    link_to_unless(current_country_code == country_code, text, "/#{country_code}")
  end

  def m(money)
    symbol = money.currency == 'GBP' ? '&pound;' : '$'
    "#{symbol}#{money}"
  end

  def n(value)
    value ? value : '&mdash;'
  end

  def p(numerator, denominator)
    "(#{number_to_percentage(100 * numerator.to_f / denominator, :precision => 0)})" unless denominator.zero?
  end

  def paypal_donation_service_for(order, account, options = {})
    payment_service_for(order, (ActiveMerchant::Configuration.override_paypal_account || account), options.merge(:service => :paypal)) do |service|
      service.cmd = '_donations'
      yield service
    end
  end

  def highlight?(item, batch)
    item.batch == batch
  end
end
