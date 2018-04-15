class CreateHooks
  include Interactor
  include InteractorHelper

  REPOS_PRD = ['woodmont/capital', 'woodmont/listings', 'phstc/putslabel', 'phstc/crosshero'].freeze
  REPOS_STG = ['phstc/putslabel'].freeze
  WEBHOOK_URL_PRD = 'https://putslabel.herokuapp.com/webhook'.freeze
  WEBHOOK_URL_STG = 'https://putslabel-stg.herokuapp.com/webhook'.freeze

  def call
    # TODO Make this configuration based on ENV, not on ifs
    if ENV['PRODUCTION'] == 'true'
      repos = REPOS_PRD
      url = WEBHOOK_URL_PRD
    elsif ENV['STAGING'] == 'true'
      repos = REPOS_STG
      url = WEBHOOK_URL_STG
    else
      # NOOP webhooks don't work against localhost
      return
    end

    repos.each do |repo|
      client.create_hook(
        repo,
        'web',
        {
          url: url,
          content_type: 'json'
        },
        events: %w[issues status pull_request_review push pull_request],
        active: true
      )
    rescue Octokit::UnprocessableEntity
      # TODO ignore if hook is already in place
      # otherwise log it in an error tracker
    end
  end
end
