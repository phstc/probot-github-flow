class CreateHooks
  include InteractorHelpers

  attr_reader :context

  REPOS = ['woodmont/capital', 'woodmont/listings', 'phstc/putslabel', 'phstc/crosshero'].freeze
  WEBHOOK_URL = 'https://putslabel.herokuapp.com/webhook'.freeze

  class << self
    def call!(context = {})
      new(context).call
    end
  end

  def initialize(context)
    @context = OpenStruct.new(context)
  end

  def call
    REPOS.each do |repo|
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

    context
  end
end
