# frozen_string_literal: true

# decorator to facilitate the sale of user credits
module Spree
  module DigitalDecorator
    def user_credits?
      variant.user_credits?
    end
  end
end

Spree::Digital.prepend Spree::DigitalDecorator if Spree::Digital.included_modules.exclude?(Spree::DigitalDecorator)
