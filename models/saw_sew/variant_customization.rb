# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it is used to relate customizations to variants
  class VariantCustomization < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_variant_customizations'

    # the customizable is the user input source for the customization
    # currently this is a product component exclusively
    belongs_to :customization,
                class_name: 'SawSew::Customization'

    # customizations belong to a variant
    # these variants are all state option values for the customization option type
    belongs_to :variant,
                class_name: 'Spree::Variant'

  end
end
