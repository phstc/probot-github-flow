class GitHub
  attr_reader :client, :repo_full_name

  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def handle_github(type, payload)
    @repo_full_name = payload['repository']['full_name']

    SetupLabels.call!(repo_full_name: repo_full_name)

    case type
    when 'pull_request_review'
      Webhooks::HandlePullRequestReview.call!(payload: payload, repo_full_name: repo_full_name)
    when 'pull_request'
      Webhooks::HandlePullRequest.call!(payload: payload, repo_full_name: repo_full_name)
    when 'issues'
      Webhooks::HandleIssues.call!(payload: payload, repo_full_name: repo_full_name)
    end
  end
end
