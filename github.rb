class GitHub
  READY_FOR_REVIEW = 'ready for review'.freeze # #fef2c0
  REJECTED = 'rejected'.freeze # #e11d21
  REVIEW_REQUESTED = 'review requested'.freeze # #fef2c0
  IN_PROGRESS = 'in progress'.freeze # #1d76db

  attr_reader :client, :repo_full_name

  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def handle_github(type, payload)
    @repo_full_name = payload['repository']['full_name']

    SetupLabels.call!(repo_full_name: repo_full_name)

    case type
    when 'pull_request_review'
      HandleReviewRequested.call!(payload: payload, repo_full_name: repo_full_name)
    when 'pull_request'
      handle_github_pull_request(payload)
    when 'issues'
      Webhooks::HandleIssues.call!(payload: payload)
    end
  end

  def handle_github_pull_request(payload)
    if %w[opened edited closed reopened].include?(payload['action'])
      update_referenced_issues_desc(payload)

      close_referenced_issues(payload) if payload['action'] == 'closed' && payload['pull_request']['merged'].to_s == 'true'
    elsif payload['action'] == 'review_requested'
      review_requested_issue(payload)
    end
  end

  private

  def update_referenced_issues_desc(payload)
    number = payload['pull_request']['number']

    Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
      issue = client.issue(repo_full_name, id)

      action = payload['action']

      body = if action == 'closed'
               remove_pr_reference(number, issue)
             else
               client.add_assignees(repo_full_name, id, [payload['pull_request']['user']['login']])
               add_in_progress(issue)
               add_pr_reference(action, number, issue)
             end

      next unless body

      client.update_issue(repo_full_name, id, issue['title'], body)
    end
  end

  def add_in_progress(issue)
    return if issue['labels'].any? { |label| label['name'] == READY_FOR_REVIEW }

    id = issue['number']

    AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: IN_PROGRESS)
  end

  def close_referenced_issues(payload)
    Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
      client.close_issue(repo_full_name, id)

      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: [IN_PROGRESS, READY_FOR_REVIEW, REVIEW_REQUESTED, REJECTED]
      )
    end
  end

  def remove_pr_reference(number, issue)
    body = issue['body'].to_s
    body.gsub("**PR:** ##{number}", "<strike>**PR:** ##{number}</strike>")
  end

  def add_pr_reference(action, number, issue)
    body = issue['body'].to_s

    body.gsub!("<strike>**PR:** ##{number}</strike>", '') if action == 'reopened'

    return if body.include?("**PR:** ##{number}")

    body += "\n" unless body.include?('**PR:**')

    body + "\n**PR:** ##{number}"
  end

  def review_requested_issue(payload)
    Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
      AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: REVIEW_REQUESTED)
    end
  end
end
