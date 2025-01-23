# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # user credits are for AI usage (at the moment)
  # each user has one user credit record that tracks their credit balance and transactions
  # this is setup as a separate table vs a column in the user table as we anticipate this functionality to grow
  class UserCredit < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_user_credits'

    belongs_to :user,
                class_name: 'Spree::User'

    has_many :transactions,
              class_name: 'SawSew::UserCreditTransaction',
              dependent: :destroy

    has_many :events,
             through: :transactions,
             source: :originator,
             source_type: 'SawSew::PipEvent'
  end
end
