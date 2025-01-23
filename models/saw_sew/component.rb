# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # components are objects that exist within configurator instances
  # they are defined in the configurators associated grasshopper definition and can be
  # inputs - user defined values (a slider)
  # outputs - values calculated by the definition (geometries to display)
  class Component < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_components'

    # components belong to configurators
    # configurators use components to display and manipulate data (outputs and parameters)
    belongs_to :configurator,
                class_name: 'SawSew::Configurator'

    # components can have many inputs
    ## these can be HTML inputs, glTF material attributes...
    has_one :component_input,
            dependent: :destroy,
            class_name: 'SawSew::ComponentInput'

    has_one :input,
             through: :component_input,
             class_name: 'SawSew::Input'

    # components can have many input values for their inputs
    ## these can be default, min/max values...
    has_many :component_input_values,
             dependent: :destroy,
             class_name: 'SawSew::ComponentInputValue'

    has_many :input_values,
             through: :component_input_values,
             class_name: 'SawSew::InputValue'

    has_many :input_properties,
             through: :component_input_values,
             class_name: 'SawSew::InputProperty'

    # components can have many taxons
    ## used to match products for inputs...
    has_many :component_taxons,
             dependent: :destroy,
             class_name: 'SawSew::ComponentTaxon'

    has_many :taxons,
             through: :component_taxons,
             class_name: 'Spree::Taxon'

    # products can have many components via product_components join table
    # these are ofter referred to as customizables
    has_many :product_components,
              dependent: :destroy,
              class_name: 'SawSew::ProductComponent'

    def descriptive_name
      "#{configurator.name.titlecase} -> Component -> #{name.titlecase}"
    end

    def input_max
      component_input_values.joins(:input_property).find_by(input_property: { name: :max })&.input_value&.value
    end

    def input_min
      component_input_values.joins(:input_property).find_by(input_property: { name: :min })&.input_value&.value
    end

    def input_step
      component_input_values.joins(:input_property).find_by(input_property: { name: :step })&.input_value&.value
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[input input_values input_properties taxons]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[component_type configurator_id created_at id name visible]
    end
  end
end
