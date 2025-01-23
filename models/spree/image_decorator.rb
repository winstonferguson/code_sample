# frozen_string_literal: true

# decorator to update default image style
module Spree
  module ImageDecorator
    module ClassMethods
      def styles
        {
          # change existing default sizes used in Admin Panel and API
          mini:    '48x48>',
          small:   '100x100>',
          product: '240x240>',
          large:   '1200x1200>',
          plp:    '500x500>',
          pdp_thumbnail: '160x200>',
          plp_and_carousel: '448x600>',
          plp_and_carousel_xs: '254x340>',
          plp_and_carousel_sm: '350x468>',
          plp_and_carousel_md: '222x297>',
          plp_and_carousel_lg: '695x928>',
          zoomed: '650x870>'
        }
      end
    end

    def self.prepended(base)
      base.inheritance_column = nil
      base.singleton_class.prepend ClassMethods
    end
  end
end
Spree::Image.prepend Spree::ImageDecorator if Spree::Image.included_modules.exclude?(Spree::ImageDecorator)
