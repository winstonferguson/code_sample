# frozen_string_literal: true

# decorator to facilitate the sale of user credits
# it overides spree's create_digital_links method to assign user credits to the user
# https://github.com/spree/spree/blob/23a20a2cbf298910e698eced5b705f9071ec5272/core/app/models/spree/order/digital.rb
module Spree
  class Order < Spree::Base
    module DigitalDecorator
      def create_digital_links
        digital_line_items.each do |line_item|
          line_item.variant.digitals.each do |digital|
            if digital.user_credits?
              SawSew::Pip::AssignUserCredits.call(digital: digital, line_item: line_item)
            else
              line_item.digital_links.create!(digital: digital)
            end
          end
        end
      end
    end
  end
end

Spree::Order::Digital.prepend Spree::Order::DigitalDecorator if Spree::Order::Digital.included_modules.exclude?(Spree::Order::DigitalDecorator)
