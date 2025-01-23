# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # this table connects product components to input files
  # for example, a product component may use an image file as a label
  class ProductComponentInputFile < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_product_component_input_files'

    belongs_to :input_file,
                polymorphic: true,
                class_name: 'SawSew::InputFile'

    belongs_to :product_component,
               class_name: 'SawSew::ProductComponent'
  end
end
