# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this facilitates active storage for our input files
  # as our input
  # based on https://github.com/spree/spree/blob/0c71e73d58a9649ce57f0f78153e73e5be74832a/core/app/models/spree/asset/support/active_storage.rb
  class InputFile < Spree::Asset
    module Configuration
      module ActiveStorage
        extend ActiveSupport::Concern

        included do
          if Spree.public_storage_service_name
            has_one_attached :attachment, service: Spree.public_storage_service_name
          else
            has_one_attached :attachment
          end

          validates :attachment, content_type: /\Aimage\/.*\z/

          default_scope { includes(attachment_attachment: :blob) }

          def self.styles
            @styles ||= {
              small: '100x100>',
              thumbnail: '50x50>',
              thumb: '80x80>',
              normal: '600x600>'
            }
          end

          def default_style
            :normal
          end
        end
      end
    end
  end
end
