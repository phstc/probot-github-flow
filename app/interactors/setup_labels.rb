class SetupLabels
  include Interactor
  include InteractorHelpers

  READY_FOR_REVIEW = 'ready for review'.freeze # #fef2c0
  REJECTED = 'rejected'.freeze # #e11d21
  REVIEW_REQUESTED = 'review requested'.freeze # #fef2c0
  IN_PROGRESS = 'in progress'.freeze # #1d76db

  def call
    [[READY_FOR_REVIEW, 'fef2c0'],
     [REJECTED, 'e11d21'],
     [REVIEW_REQUESTED, 'fef2c0'],
     [IN_PROGRESS, '1d76db']].each do |label, color|

      client.add_label(repo_full_name, label, color)
    rescue Octokit::UnprocessableEntity
    end
  end
end
