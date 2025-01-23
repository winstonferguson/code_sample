# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this tables stores values (strings) that are used to update objects in a configurators 3D environment
  # these values may be assigned to
  # - components -> i.e. inherited (via sync) default values
  # - input properties -> i.e. min, max, step
  # - variants -> i.e. roughness/metallic factor
  # - product components -> i.e. labels
  class InputValue < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_input_values'

    has_many :component_input_values,
              dependent: :destroy

    has_many :components,
              through: :component_input_values

    has_many :input_property_input_values,
              dependent: :destroy

    has_many :input_properties,
              through: :input_property_input_values

    has_many :variant_input_values,
              dependent: :destroy

    has_many :variants,
              through: :variant_input_values

    has_many :product_component_input_values,
              dependent: :destroy

    has_many :product_components,
              through: :product_component_input_values

    scope :labels,
      -> { joins(:input_properties).where(input_properties: { name: 'label' }) }

		scope :tooltips,
      -> { joins(:input_properties).where(input_properties: { name: 'tooltip' }) }

    scope :not_labels,
    	-> { joins(:input_properties).where.not(input_properties: { name: 'label' }) }

    scope :prompts,
      -> { joins(:input_properties).where(input_properties: { name: 'prompt' }) }

    scope :input_min,
      -> { joins(:input_properties).where(input_properties: { name: 'min' }) }
    scope :input_max,
      -> { joins(:input_properties).where(input_properties: { name: 'max' }) }
    scope :input_step,
      -> { joins(:input_properties).where(input_properties: { name: 'step' }) }

    scope :materials,
      -> { joins(:input_properties).where(input_properties: { material: true }) }

    def assignees
      [input_properties.map(&:descriptive_name) + components.map(&:descriptive_name)].flatten.to_sentence
    end

    def label?
      property_names.length == 1 && property_names.first == 'label'
    end

    def property_names
      input_properties.map(&:name)
    end
  end
end
