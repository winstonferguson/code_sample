# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it is used to associate inputs with components
  # this is generated when a component is created via a configurator sync (see service SawSew::SyncComponents)
  class ComponentInput < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_component_inputs'

    belongs_to :input,
                class_name: 'SawSew::Input'

    belongs_to :component,
                class_name: 'SawSew::Component'
  end
end
