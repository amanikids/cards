module ApplicationHelper
  def cycle_letter_classes(string, *classes)
    string.split(//).map do |c|
      c.blank? ? c : content_tag(:span, c, :class => cycle(*classes))
    end.join
  end

  def n(value)
    value ? value : '&mdash;'
  end

  def paypal_donation_service_for(order, options = {})
    payment_service_for(order, ActiveMerchant::Configuration.paypal_account, options.merge(:service => :paypal)) do |service|
      service.cmd = '_donations'
      yield service
    end
  end
end