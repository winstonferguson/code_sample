# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # inputs are used to update objects in a configurators 3D environment
  class Input < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_inputs'

    # inputs come from components
    has_many :component_inputs,
             inverse_of: :input,
             dependent: :destroy
    has_many :components,
             through: :component_inputs

    # inputs have properties
    ## NOTE: this could be refactored for STI as, currently, both inputs and input properties only have a name attribute
    has_many :input_property_inputs,
             class_name: 'SawSew::InputPropertyInput',
             dependent: :destroy

    has_many :input_properties,
             class_name: 'SawSew::InputProperty',
             dependent: :destroy

    validates :name,
              presence: true,
              uniqueness: true

    def property_names
      input_properties.map(&:name).join(', ')
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[name]
    end
  end
end
