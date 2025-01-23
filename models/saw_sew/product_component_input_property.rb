# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects product components to input properties
  # this would be used to define properties the product component accepts
  # for example, image texture types (normal map, roughness map, ao map...) used in a product component
  class ProductComponentInputProperty < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_component_input_properties'

    belongs_to :input_property,
                class_name: 'SawSew::InputProperty'

    belongs_to :product_component,
               class_name: 'SawSew::ProductComponent'
  end
end
