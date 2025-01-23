# frozen_string_literal: true

# this decorator addresseses functionality related to our Pip AI and the user's ability to customize products
module Spree
  module UserDecorator
    def self.prepended(base)
      # users have credit
      # this is created when the user is created
      # currently this is a single record to use with our AI Pip
      base.has_one :user_credit,
                    class_name: 'SawSew::UserCredit',
                    dependent: :destroy

      # user pip events are the events that the user has created using the AI Pip
      base.has_many :pip_events,
                    through: :user_credit,
                    source: :events

      # users can have many variants
      # user variants are customizations of a product
      base.has_many :user_variants,
                    class_name: 'SawSew::UserVariant',
                    dependent: :destroy

      base.has_many :variants,
                    class_name: 'Spree::Variant',
                    through: :user_variants

      # create the user credit record
      # this is needed as we offer free credits on sign up and on a monthly basis
      base.after_create :create_user_credit

    end

    # create the a user credit record
    def create_user_credit
      SawSew::UserCredit.create(user: self, credits: 12)
    end

    def pip_credits
      user_credit[:credits] || 0
    end

    # we record all the events but only successful events have images
    # this is used to show the user their successful events
    def pip_events_with_images
      pip_events.where("(result -> 'image_urls') is not null")
    end
  end
end

Spree::User.prepend Spree::UserDecorator if Spree::User.included_modules.exclude?(Spree::UserDecorator)
