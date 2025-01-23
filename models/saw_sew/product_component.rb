# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this table relates product with components
  # it is used to create configurable products
  # as configurators have many components and products may not require all components for their customization
  # this table is used to define the components that are required for product customizations
  # it also relates any input values or input files that are required for the component
  # this model is often referred to as a customizable in the application and should probably be renamed
  class ProductComponent < ApplicationRecord
    include Rails.application.routes.url_helpers
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_components'

    # acts_as_list is a gem that allows us to order the components
    acts_as_list

    belongs_to :product,
                class_name: 'Spree::Product'

    belongs_to :component,
                class_name: 'SawSew::Component'

    has_one :customization,
            class_name: 'SawSew::Customization',
            dependent: :destroy

    # input files join table
    has_many :product_component_input_files,
              dependent: :destroy

    # inputs join table
    has_many :product_component_inputs,
              dependent: :destroy

    # inputs
    has_many :inputs,
             through: :product_component_inputs

    # input properties join table
    has_many :product_component_input_properties,
             dependent: :destroy

    # input properties
    has_many :input_properties,
             through: :product_component_input_properties

    # input values join table
    has_many :product_component_input_values,
              dependent: :destroy

    # input values
    has_many :input_values,
              through: :product_component_input_values

    scope :customizables, -> { where(visible: true) }
    scope :materials, -> { where(material: true) }
    scope :root, -> { where(group: 'root') }
    scope :branch, -> { where.not(group: 'root') }

    after_create :set_material_properties

    delegate :input_min, :input_max, :input_step, to: :component

    def input
      inputs.first || component.input
    end

    # input files are retrieved through the product master variant
    # this is because input files are assigned via polymorphic viewable association
    # and we can use the existing Spree::Variant association vs create a new model specifically for attaching files
    def input_files
      return [] unless product_component_input_files.any?

      product
        .master
        .input_files
        .joins(:product_component_input_files)
        .where(product_component_input_files: { product_component_id: id })
    end

    def input_options
      options = {}
      options[:min] = input_min if input_min
      options[:max] = input_max if input_max
      options[:step] = input_step if input_step
      options
    end

    def label
      return component.name unless input_values.labels.any?

      input_values.labels.first.value
    end

    # some product components use images for labels
    def label_image
      return nil unless product_component_input_files.any?

      product.master.input_files.labels
        .joins(:product_component_input_files)
        .where(product_component_input_files: { product_component_id: id })
        .first
    end

    # what material property is it
    def material_property
      return nil unless material?
      return 'map' if input_properties.length == 1

      input.name.downcase
    end

    def parts
      return [] unless component.taxons.any?

      product.parts
        .where(is_master: true)
        .joins(:classifications)
        .where(classifications: { taxon_id: component.taxons })
    end

    def tooltip
      input_values.tooltips.first.value
    end

    def tooltip?
      input_values.tooltips.any?
    end
  end
end
