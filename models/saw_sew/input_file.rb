# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # input files are instances of Spree::Asset and are polymorphic
  class InputFile < Spree::Asset
    include SawSew::InputFile::Configuration::ActiveStorage
    include Rails.application.routes.url_helpers
    include Spree::ImageMethods

    # input files may be assigned via input properties
    # like an image for a normal map
    has_many :input_property_input_files,
             class_name: 'SawSew::InputPropertyInputFile',
             dependent: :destroy

    has_many :input_properties,
              through: :input_property_input_files

    # input files may be assigned via components
    # like an icon for a color picker
    has_many :product_component_input_files,
              class_name: 'SawSew::ProductComponentInputFile',
              dependent: :destroy

    has_many :product_components,
             through: :product_component_input_files

    scope :labels,
          -> { joins(:input_properties).where(input_properties: { name: 'label' }) }

    scope :not_labels,
          -> { joins(:input_properties).where.not(input_properties: { name: 'label' }) }

    scope :materials,
          -> { joins(:input_properties).where(input_properties: { material: true }) }


    def assignees
      [input_properties.map(&:descriptive_name)].flatten.to_sentence
    end

    def label?
      property_names.length == 1 && property_names.first == 'label'
    end

    def property_names
      input_properties.map(&:name)
    end

    def as_file_path_source
      attachment.blob.url
    end

    # override the spree asset styles method
    def styles
      self.class.styles.map do |_, size|
        width, height = size[/(\d+)x(\d+)/].split('x').map(&:to_i)

        {
          url: generate_url(size: size),
          size: size,
          width: width,
          height: height
        }
      end
    end
  end
end
