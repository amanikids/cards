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

  def public_image_paths
    images = Rails.root.join('public', 'images')

    images.enum_for(:find).
      select  { |file| file.file? }.
      collect { |file| file.relative_path_from(images) }.
      sort
  end
end
