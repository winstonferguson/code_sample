module Spree
  module Admin
    module Tabs
      # rubocop:disable Metrics/ClassLength
      module ProductDefaultTabsBuilderDecorator
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_details_tab(root)
          add_images_tab(root)
          add_variants_tab(root)
          add_properties_tab(root)
          add_stock_tab(root)
          add_prices_tab(root)
          add_parts_tab(root)
          add_configurators_tab(root)
          add_input_values_tab(root)
          add_digitals_tab(root)
          add_translations_tab(root)
          root
        end

        private

        def add_parts_tab(root)
          tab =
            TabBuilder.new('parts', ->(resource) { admin_product_parts_path(resource) }).
            with_icon_key('th').
            with_active_check.
            with_admin_ability_check(::Spree::Product).
            build

          root.add(tab)
        end

        def add_configurators_tab(root)
          tab =
            TabBuilder.new('configurators', ->(resource) { admin_edit_product_configurator_path(resource) }).
            with_icon_key('badge-3d-fill.svg').
            with_active_check.
            with_admin_ability_check(::Spree::Product).
            build

          root.add(tab)
        end

        def add_input_values_tab(root)
          tab =
            TabBuilder.new('inputs', ->(resource) { admin_product_input_values_path(resource) }).
            with_icon_key('input-cursor.svg').
            with_active_check.
            with_admin_ability_check(::Spree::Product).
            build

          root.add(tab)
        end
      end
    end
  end

Spree::Admin::Tabs::ProductDefaultTabsBuilder.prepend Spree::Admin::Tabs::ProductDefaultTabsBuilderDecorator if Spree::Admin::Tabs::ProductDefaultTabsBuilder.included_modules.exclude?(Spree::Admin::Tabs::ProductDefaultTabsBuilderDecorator)
end
