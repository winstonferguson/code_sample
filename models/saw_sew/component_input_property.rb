# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it is used to relate input properties to a component
  # these records are generated when a component is created via a configurator sync (see service SawSew::SyncComponents)
  class ComponentInputProperty < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_component_input_properties'

    belongs_to :input_property,
                class_name: 'SawSew::InputProperty'

    belongs_to :component,
                class_name: 'SawSew::Component'
  end
end
