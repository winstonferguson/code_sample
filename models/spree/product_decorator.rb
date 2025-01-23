# frozen_string_literal: true

# this decorator updates the spree product model to work with our configurator
module Spree
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :configurator,
                      class_name: 'SawSew::Configurator',
                      optional: true

      # products can have many input values for their variants
      # these can be normal maps, texture scaling, texture positioning...
      base.has_many :input_values,
                     through: :variants_including_master

      # product components are configurator components linked to the product
      # these are configurator inputs
      base.has_many :product_components,
                    dependent: :destroy,
                    class_name: 'SawSew::ProductComponent'

      base.has_many :components,
                    class_name: 'SawSew::Component',
                    through: :product_components

      # we often refer to product components as customizables
      base.has_many :customizables,
                    -> { customizables.order(position: :asc) },
                    class_name: 'SawSew::ProductComponent'

      # material product components are handled differently
      # we can process them their updates within our frontend
      # as they don't require updates to the parametric model
      base.has_many :materials,
                    -> { materials },
                    class_name: 'SawSew::ProductComponent'


      # input images are used in configurators
      # they're texture images like normal, opacity...
      base.has_many :input_files,
                    source: :input_files,
                    through: :variants_including_master

      # the spree base scope wasn't behaving as expected
      # it was showing parts that are not available to the user
      # so we've defined a base scope for products
      base.scope :sawsew_base_scopes, -> { where(individual_sale: true).order("created_at DESC") }
    end

    # this is used by our AI Pip
    # it concatenates the prompts to create a base prompt
    def base_prompt
      input_values.prompts.map(&:value).join(" ")
    end

    # logic to determine if a product can be customized
    def customizable?
      configurator.present?
    end

    # # we pass this information to the frontend
    # def configurator_inputs
    #   product_components.where(visible: false).map(&:configurator_inputs).flatten.to_json
    # end

    def configurator_materials
      materials.map(&:configurator_inputs).flatten.to_json
    end

    # this was used when we were setting up credits as variants
    # this was deprecated as we moved to a credit system
    # TODO: remove this
    def digital?
      shipping_category&.shipping_methods&.any? { |method| method.calculator.is_a?(Spree::Calculator::Shipping::DigitalDelivery) }
    end

    # #
    # def shopable_variants
    #   variants.shoppable
    # end

    # logic to determine if the product can be customized by Pip AI
    # used to show AI badge in shop
    def pip_customizable?
      pip_customizable.present?
    end

    # check if the product has an AI input value
    # currently, this can only be a base prompt
    def pip_customizable
      customizables.joins(:inputs).where(inputs: {name: "AI"}).first
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator if Spree::Product.included_modules.exclude?(Spree::ProductDecorator)
