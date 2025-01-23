# frozen_string_literal: true

# decorator to update the spree mailers to our mailers
module Spree
  module OrderDecorator
    # this is taken from the spree core

    def deliver_order_confirmation_email
    #   # you can overwrite this method in your application / extension to send out the confirmation email
    #   # or use `spree_emails` gem
      SawSew::OrderMailer.confirmation_email(self).deliver_now # `id` = ID of the Order being sent, you can also pass the entire Order
      update_column(:confirmation_delivered, true) # if you would like to mark that the email was sent
    end

    # If you would like to also send confirmation email to store owner(s)
    def deliver_store_owner_order_notification_email?
      true
    end

    def deliver_store_owner_order_notification_email
      # you can overwrite this method in your application / extension to send out the confirmation email
      # or use `spree_emails` gem
      SawSew::OrderMailer.store_owner_notification_email(self).deliver_now # `id` = ID of the Order being sent, you can also pass the entire
      update_column(:store_owner_notification_delivered, true) # if you would like to mark that the email was sent
    end

    def send_cancel_email
      # you can overwrite this method in your application / extension to send out the confirmation email
      # or use `spree_emails` gem
      SawSew::OrderMailer.cancel_email(self) # `id` = ID of the Order being sent, you can also pass the entire Order object using `self`
    end
  end
end

Spree::Order.prepend Spree::OrderDecorator if Spree::Order.included_modules.exclude?(Spree::OrderDecorator)
