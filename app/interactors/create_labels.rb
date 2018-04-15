class CreateLabels
  include Interactor
  include InteractorHelpers

  def_delegators :context, :repo_full_name

  def call
    [[Constants::READY_FOR_REVIEW, 'fef2c0'],
     [Constants::REJECTED, 'e11d21'],
     [Constants::REVIEW_REQUESTED, 'fef2c0'],
     [Constants::IN_PROGRESS, '1d76db']].each do |label, color|

      client.add_label(repo_full_name, label, color)
    rescue Octokit::UnprocessableEntity
    end
  end
end
