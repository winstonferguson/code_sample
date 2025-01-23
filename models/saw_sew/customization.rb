# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # customizations are records of the component values for a product variant
  # they are generated when a customized variant is created
  # they are updated everytime a product component (customizable) is updated for the associated variant
  class Customization < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_customizations'

    belongs_to :input_value,
                class_name: 'SawSew::InputValue'

    belongs_to :product_component,
                class_name: 'SawSew::ProductComponent'

    belongs_to :variant,
                class_name: 'Spree::Variant'

    has_one :customization_part,
            class_name: 'SawSew::CustomizationPart',
            dependent: :destroy

    has_one :part,
            through: :customization_part,
            source: :variant

    has_one :product,
            through: :variant


    delegate :material, :component, to: :product_component
    delegate :value, to: :input_value

    # all the information needed to send to the frontend configurator instance
    def configurator_hash
      {
        customizable_id: product_component.id,
        customization_id: id,
        label: label,
        material_property: material_property,
        part_id: part&.id,
        ref: component.name,
        value: value
      }
    end

    # used to display the customization to the user
    def description
      return "#{label}: #{part.option_name}" if part

      "#{label}: #{value}"
    end

    # not all cusmtomizations are displayed in the cart
    def ignore_in_cart?
      return true if product_component.input.name == "AI"
      return true if product_component.input.name == "File"

      false
    end

    # if it's a color we can present a coloured div element
    def is_color?
      value.slice(1..6) =~ /^[0-9A-F]+$/i
    end

    # what's it's material property
    def material_property
      product_component.material_property
    end

    # a customization may require specific quantity of a part
    def part_count
      product.assemblies_parts
        .where(part_id: part.product.master_id)
        .pluck(:count)
        .sum
    end

    # calculate the part price
    def part_price
      return 0 unless part

      part.price * part_count
    end

    def price
      part_price
    end
  end
end
