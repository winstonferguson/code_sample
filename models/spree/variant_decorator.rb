# frozen_string_literal: true

# decorator to address our application's capacity to customize products
# and show them in the shop or relate them to users
module Spree
  module VariantDecorator
    def self.prepended(base)
      # base.include SawSew::Concerns::MaterialInputMethods
      # base.include SawSew::Concerns::Componential

      # variants can have many input values
      ## these can be normal maps, texture scaling, texture positioning...
      base.has_many :variant_input_values,
                    class_name: 'SawSew::VariantInputValue',
                    dependent: :destroy
      base.has_many :input_values,
                    class_name: 'SawSew::InputValue',
                    through: :variant_input_values

      # input files are used in configurators
      # they're texture images like normal, opacity...
      base.has_many :input_files,
                    as: :viewable,
                    dependent: :destroy,
                    class_name: 'SawSew::InputFile'

      # as variants can now have two types of images (Spree::Image and SawSew::InputFiles)
      # we need to specify that for images we only want images without type
      # this will only return Spree::Image objects as the type is nil
      base.has_many :images,
                    -> { where(type: nil).order(:position) },
                    as: :viewable,
                    dependent: :destroy,
                    class_name: 'Spree::Image'

      base.has_many :classifications,
                    class_name: 'Spree::Classification',
                    through: :product


      # variants can have many customizations
      base.has_many :customizations,
                    class_name: 'SawSew::Customization'

      # variants can belong to a user
      # these are the customized variants that the user has saved
      base.has_one :user_variant,
                    class_name: 'SawSew::UserVariant',
                    dependent: :destroy

      base.has_one :user,
                    through: :user_variant

      # we're showing variants in our shop pages
      # spree shows products in the shop pages
      # this scope is used to filter out variants that are not shoppable
      base.scope :shoppable, -> { includes(:user_variant).where(user_variant: { id: nil }) }

      # expiring variants are used to track variants that have been created by guests
      # a guest can create a variant but it will be deleted after a certain amount of time
      # we use the spree token to link it to the guest
      base.scope :expired, -> { where('expires_at < ?', Time.current) }
      base.scope :nonexpired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

      def component_value(component_id)
        input_values.joins(:components).find_by(components: { id: component_id })&.value
      end

      def customization_value(customizable_id)
        customizations.find_by(product_component_id: customizable_id)&.input_value&.value
      end

      def configurator_customizations
        # we want all non material customizations first
        # as we'll need to wait for the geometry to be updated before we can apply the material customizations
       customizations.sort_by { |c| [c.material_property ? 1 : 0, c] }
        .map(&:configurator_hash)
        .to_json
      end


      # get the configurator inputs for the variant
      # this may include input values and input files
      # for example, a material scale input value or a normal map input file
      def configurator_inputs
        [input_values + input_files].flatten.filter_map do |input|
          {
            name: name,
            properties: input.property_names,
            value:
              input.class == SawSew::InputFile ?
                input.as_file_path_source
                : input.value
          }
        end
      end

      # get the value of an input property by name
      def input_property_value(name)
        input_values.joins(:input_properties).find_by(input_properties: { name: })&.value
      end

      # spree's default image method wasn't working as expected
      # as the spree library is riddled with bugs and in the process of a major overhaul
      # we've defined our own image method vs digging through the core
      def mailer_image_url
        return images.first.attachment.blob.url if images.any? && images.first.attachment&.blob&.present?
        return product.stores.first.logo.attachment.blob.url if product&.stores&.first&.logo&.present?

        ''
      end

      # used when the variant is acting as a part
      # the user will know the 'option name' as the input label in the configurator
      # TODO: refactor this so that this is defined at the product level
      def option_name
        input_property_value(:label)
      end

      # used when the variant is acting as a part
      # we may want a special value to refer to the variant in an input
      # for example, a 30cm square cushion may be referred to as simply 30cm
      def option_value(component_id)
        component_value(component_id) || id
      end

      # as we're showing variants in the shop
      # they need names
      def shoppable_name
        return shop_name unless shop_name.nil?

        product.name
      end

      def state
        private_metadata['state']
      end


      def user_credits?
        product.sku == 'SS-AI-CR'
      end

      def user_credits
        options.find { |o| o if o[:name] == "credits"}
      end

      def user_customization?
        user.present?
      end

      # in case the variants method is passed
      # we're using variants in the shop which spree does not
      # TODO: update to delegation
      def variants
        product.variants
      end
    end
  end
end

Spree::Variant.prepend Spree::VariantDecorator if Spree::Variant.included_modules.exclude?(Spree::VariantDecorator)
