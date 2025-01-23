# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # this table connects product components to input values
  # these would be considered default values
  class ProductComponentInputValue < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_component_input_values'

    belongs_to :input_value,
                class_name: 'SawSew::InputValue'

    belongs_to :product_component,
               class_name: 'SawSew::ProductComponent'
  end
end
