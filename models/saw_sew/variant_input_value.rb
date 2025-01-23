# frozen_string_literal: true
#
# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it is used to relate input values to variants
  class VariantInputValue < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_variant_input_values'

    belongs_to :input_value,
                class_name: 'SawSew::InputValue'

    belongs_to :variant,
                class_name: 'Spree::Variant'
  end
end
