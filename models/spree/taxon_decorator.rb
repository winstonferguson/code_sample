# frozen_string_literal: true

# we have private taxonomies that we don't want to show in the frontend
# they are used to match parts to inputs
# aka matching product variants to be used in creation of new product variants via customizables (product components)
module Spree
  module TaxonDecorator
    def self.prepended(base)
      # check to see if the taxon is visible
      # based on the name of the taxonomy
      def visible?
        taxonomy.name.downcase != 'private'
      end
    end
  end
end

Spree::Taxon.prepend Spree::TaxonDecorator if Spree::Taxon.included_modules.exclude?(Spree::TaxonDecorator)
