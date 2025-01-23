# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects input properties to input values
  class InputPropertyInputValue < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_input_property_input_values'

    belongs_to :input_value,
                class_name: 'SawSew::InputValue'

    belongs_to :input_property,
               class_name: 'SawSew::InputProperty'
  end
end
