# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it is used to associate inputs with input values
  # this is generated when a component is created via a configurator sync (see service SawSew::SyncComponents)
  # component input values are default values
  class ComponentInputValue < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_component_input_values'

    belongs_to :input_property,
                class_name: 'SawSew::InputProperty',
                optional: true

    belongs_to :input_value,
                class_name: 'SawSew::InputValue'

    belongs_to :component,
                class_name: 'SawSew::Component'


    alias_attribute :value, :input_value
    alias_attribute :property, :input_property
  end
end
