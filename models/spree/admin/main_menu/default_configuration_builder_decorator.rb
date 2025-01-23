module Spree
  module Admin
    module MainMenu
      module DefaultConfigurationBuilderDecorator
        # we are overriding the build method to add a new section to the main menu
        # and put it where we want it
        def build
          root = Root.new
          add_dashboard_item(root)
          add_orders_section(root)
          add_returns_section(root)
          add_configurators_section(root)
          add_products_section(root)
          add_stocks_section(root)
          add_reports_item(root)
          add_promotions_section(root)
          add_users_item(root)
          add_content_section(root)
          add_integrations_section(root)
          add_oauth_section(root)
          add_settings_section(root)
          root
        end

        # this is our new section
        def add_configurators_section(root)
          # these are the items in the section
          items = [
            ItemBuilder.new('configurators', admin_configurators_path).
              with_manage_ability_check(SawSew::Configurator).
              with_match_path('/configurators').
              build,
            ItemBuilder.new('input_properties', admin_input_properties_path).
              with_manage_ability_check(SawSew::InputProperty).
              with_match_path('/input_properties').
              build
          ]
          # it's link and icon
          section = SectionBuilder.new('configurators', 'badge-3d-fill.svg').
                    with_manage_ability_check(SawSew::Configurator).
                    with_label_translation_key('admin.tab.configurators').
                    with_items(items).
                    build
          root.add(section)
        end

      end
    end
  end
end
::Spree::Admin::MainMenu::DefaultConfigurationBuilder.prepend Spree::Admin::MainMenu::DefaultConfigurationBuilderDecorator if ::Spree::Admin::MainMenu::DefaultConfigurationBuilder.included_modules.exclude?(Spree::Admin::MainMenu::DefaultConfigurationBuilderDecorator)
