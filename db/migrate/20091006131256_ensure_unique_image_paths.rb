class EnsureUniqueImagePaths < ActiveRecord::Migration
  def self.up
    us = Distributor.find_by_country_code('us')

    return unless us

    Product.find_all_by_image_path('cards/christmas_on_the_savannah.jpg').each do |product|
      if product.available?(us)
        product.update_attributes!(:image_path => 'cards/christmas_on_the_savannah_north_america.jpg')
      else
        product.update_attributes!(:image_path => 'cards/christmas_on_the_savannah_uk.jpg')
      end
    end
  end

  def self.down
    # Not worrying about the down migration for now.
  end
end
