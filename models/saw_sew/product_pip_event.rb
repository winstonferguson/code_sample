# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects products to pip events - AI events used in the creation of the product
  class ProductPipEvent < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_pip_events'

    belongs_to :product,
                class_name: 'Spree::Product'

    belongs_to :pip_event,
                class_name: 'SawSew::PipEvent'

  end
end
