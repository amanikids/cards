module ApplicationHelper
  def format_currency(cents, currency)
    number_to_currency cents / 100,
      :format => '%n %u',
      :unit   => currency
  end
end
