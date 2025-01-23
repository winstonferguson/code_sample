# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # defining taxons related to a component enables us to relate parts (other product variants) to that component
  # for example, a part taxon may be filling, material...
  class ComponentTaxon < ApplicationRecord
    self.table_name = 'sawsew_component_taxons'

    belongs_to :component,
               class_name: 'SawSew::Component'

    belongs_to :taxon,
               class_name: 'Spree::Taxon'
  end
end
