# frozen_string_literal: true

module SolidusTracking
  module Spree
    module MailerSubscriber
      module DisableConfirmEmail
        def self.prepended(base)
          base.module_eval do
            alias_method :original_order_finalized, :send_confirmation_email

            def send_confirmation_email(event)
              return if SolidusTracking.configuration.disable_builtin_emails

              original_order_finalized(event)
            end
          end
        end
      end
    end
  end
end

if Spree.solidus_gem_version >= Gem::Version.new('2.9.0')
  Spree::OrderMailerSubscriber.prepend(SolidusTracking::Spree::MailerSubscriber::DisableConfirmEmail)
end
