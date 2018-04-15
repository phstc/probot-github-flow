class CreateHooks
  include Interactor
  include InteractorHelper

  REPOS_PROD = ['woodmont/capital', 'woodmont/listings', 'phstc/putslabel', 'phstc/crosshero'].freeze
  REPOS_STG = ['phstc/putslabel'].freeze
  WEBHOOK_URL = 'https://putslabel.herokuapp.com/webhook'.freeze

  def call
    repos = ENV['PRODUCTION'] == 'true' ? REPOS_PROD : REPOS_STG

    repos.each do |repo|
      client.create_hook(
        repo,
        'web',
        {
          url: WEBHOOK_URL,
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
