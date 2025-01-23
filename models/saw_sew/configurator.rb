# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # configurators are CAD instances for configuring a product
  class Configurator < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_configurators'

     # configurators have many components
     # these are:
     # parameters that can be configured
     # outputs that display geometries/materials
    has_many :components,
            class_name: 'SawSew::Component',
            dependent: :destroy

    # components can have inputs
    has_many :inputs,
             through: :components,
             class_name: 'SawSew::Input'

    # configurators can have many products that are associated with them
    # products use configurators to create variants of themselves
    has_many :products,
             class_name: 'Spree::Product',
             dependent: :destroy
  end
end
