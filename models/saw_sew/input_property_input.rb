# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects inputs to input properties
  class InputPropertyInput < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_input_property_inputs'

    belongs_to :input,
                class_name: 'SawSew::Input'

    belongs_to :input_property,
                class_name: 'SawSew::InputProperty'

  end
end
