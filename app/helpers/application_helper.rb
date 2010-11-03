module ApplicationHelper
  def format_currency(cents, currency)
    options = case currency
              when 'USD', 'CAD', 'AUD'
                { :unit => '$' }
              when 'GBP'
                { :unit => '&pound;' }
              else
                { :unit => currency, :format => '%n %u' }
              end

    number_to_currency cents / 100, options
  end
end
