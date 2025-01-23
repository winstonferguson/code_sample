# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects product components to inputs
  # for example, a product component for dimensions may use an integer or float input
  class ProductComponentInput < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_component_input'

    belongs_to :input,
                class_name: 'SawSew::Input'

    belongs_to :product_component,
               class_name: 'SawSew::ProductComponent'
  end
end
