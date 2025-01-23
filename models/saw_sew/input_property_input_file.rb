# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # it connects input properties to input files
  class InputPropertyInputFile < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_input_property_input_files'

    belongs_to :input_file,
                polymorphic: true,
                class_name: 'SawSew::InputFile'

    belongs_to :input_property,
               class_name: 'SawSew::InputProperty'
  end
end
