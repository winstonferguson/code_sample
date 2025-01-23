module Spree
  module Admin
    module Actions
      module ImagesDefaultActionsBuilderDecorator
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_image_action(root)
          root
        end

        private

        def add_new_image_action(root)
          action =
            ActionBuilder.new('new_image', ->(resource) { new_admin_product_image_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('new_image_link').
            with_create_ability_check(::Spree::Image).
            build

          root.add(action)
        end

        def add_new_input_image_action(root)
          action =
            ActionBuilder.new('new_input_image', ->(resource) { new_admin_product_input_image_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('new_image_link').
            with_create_ability_check(::Spree::Image).
            build

          root.add(action)
        end
      end
    end
  end
  Spree::Admin::Actions::ImagesDefaultActionsBuilder.prepend Spree::Admin::Actions::ImagesDefaultActionsBuilderDecorator if Spree::Admin::Actions::ImagesDefaultActionsBuilder.included_modules.exclude?(Spree::Admin::Actions::ImagesDefaultActionsBuilderDecorator)
end
