# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it links a customization to its part aka a product variant
  # this records the part that was selected by the user for a customization
  class CustomizationPart < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_customization_variants'

    belongs_to :customization,
                class_name: 'SawSew::Customization'

    belongs_to :variant,
                class_name: 'Spree::Variant'

    alias_attribute :part, :variant
  end
end
