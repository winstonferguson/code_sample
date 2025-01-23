# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  class InputProperty < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_input_properties'


    has_many :component_input_properties,
              dependent: :destroy

    has_many :components,
              through: :component_input_properties

    has_many :input_property_inputs,
             dependent: :destroy

    has_many :inputs,
              through: :input_property_inputs

    has_many :input_property_input_files,
              dependent: :destroy

     has_many :input_files,
              source_type: 'SawSew::InputFile',
              through: :input_property_input_files

    has_many :input_property_input_values,
             dependent: :destroy

    has_many :input_values,
             through: :input_property_input_values

    validates_uniqueness_of :name

    scope :materials, -> { where(material: true) }


    def descriptive_name
      "Input Property -> #{name.titlecase}"
    end
  end
end
