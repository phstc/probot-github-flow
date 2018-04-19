class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  ACCESS_TOKEN = ENV['GH_ACCESS_TOKEN']

  def create
    # TODO validate secret from webhook call
    Webhooks::HandleWebhook.call!(
      access_token: ACCESS_TOKEN,
      type: request.env['HTTP_X_GITHUB_EVENT'],
      payload: JSON.parse(request.body.read)
    )
    head :ok
  end
end
