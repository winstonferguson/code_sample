# frozen_string_literal: true

# SawSew is our namespace in the application
module SawSew
  # payment method object created to use our stripe payment gateway in the application
  # it exists so we can use our custom stripe integration within spree ecommerce
  # it has no table in the database
  # it is based on the Spree::PaymentMethod::Check class so it passes the payment method tests
  # https://github.com/spree/spree/blob/3961b3f90e426ee982946342f021c4499ca7f443/core/app/models/spree/payment_method/check.rb
  # our payment process is handled by the SawSew::Checkout::PaymentIntent service object and the stripe payment element js controller
  # this is temporary as spree is updating their checkout for payment elements in v5 coming early 2025
  class StripePaymentElement < Spree::PaymentMethod
    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*)
      simulated_successful_billing_response
    end

    def cancel(*)
      simulated_successful_billing_response
    end

    def void(*)
      simulated_successful_billing_response
    end

    def source_required?
      false
    end

    def credit(*)
      simulated_successful_billing_response
    end

    private

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end
  end
end
