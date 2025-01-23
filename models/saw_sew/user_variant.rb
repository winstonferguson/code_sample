# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # this is a join table
  # that connects users to their customized products (variants)
  class UserVariant < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_user_variants'


    belongs_to :user,
                class_name: 'Spree::User',
                optional: true

    belongs_to :variant,
                class_name: 'Spree::Variant',
                dependent: :destroy

    validate :check_user

    private

    # users can create variants
    # and guests can create variants token based on their token
    # this token is set by Spree - core/lib/spree/core/controller_helpers/auth.rb
    def check_user
      return true if self.user.present? || self.token.present?
    end
  end
end
