# frozen_string_literal: true

module API
  module V2
    module Public
      class Webhooks < Grape::API
        helpers ::API::V2::WebhooksHelpers

        desc 'Webhook controller'
        params do
          requires :adapter,
                   type: String,
                   desc: 'Name of adapter for process webhook'
          requires :event,
                   type: String,
                   desc: 'Name of event can be deposit or withdraw',
                   values: { value: -> { %w[deposit withdraw] }, message: 'public.webhook.invalid_event' }
        end
        # e.g. /webhooks/bitgo/deposit
        post '/webhooks/:adapter/:event' do
          proces_webhook_event(params)
          status 200
        rescue StandardError => e
          Rails.logger.warn { "Cannot perform webhook: #{params}. Error: #{e}." }
          body errors: ["public.webhook.cannot_perfom_#{params['type']}"]
          status 422
        end
      end
    end
  end
end
