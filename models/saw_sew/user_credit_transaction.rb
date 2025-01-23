# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # tracks user AI credit transactions
  # currenty, only pip events can consume user credits
  # and spree line items can increase credits via purchases
  # there is a special interface for users to purchase credits
  class UserCreditTransaction < ApplicationRecord
    # we've prefixed the table name with the namespace name
    # to avoid potential conflicts with other tables in the database
    self.table_name = 'sawsew_user_credit_transactions'

    belongs_to :user_credit,
                class_name: 'SawSew::UserCredit'

    belongs_to :originator,
                polymorphic: true

    validates :amount, numericality: { only_integer: true }
  end
end
