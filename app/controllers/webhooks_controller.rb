class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    # TODO validate secret from webhook call
    Webhooks::HandleWebhook.call!(
      type: request.env['HTTP_X_GITHUB_EVENT'],
      payload: JSON.parse(request.body.read)
    )
    head :ok
  end
end
