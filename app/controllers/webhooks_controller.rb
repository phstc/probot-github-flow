class WebhooksController < ApplicationController
  def create
    Webhooks::HandleWebhook.call!(
      access_token: ACCESS_TOKEN,
      type: request.env['HTTP_X_GITHUB_EVENT'],
      payload: JSON.parse(request.body.read)
    )
    head :ok
  end
end
