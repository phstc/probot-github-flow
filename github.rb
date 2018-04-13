class GitHub
  READY_FOR_REVIEW = "ready for review" # #fef2c0
  REJECTED = "rejected" # #e11d21
  REVIEW_REQUESTED = "review requested" # #fef2c0
  IN_PROGRESS = "in progress" # #1d76db

  attr_reader :client, :repo_full_name

  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def add_labels
    labels = [[READY_FOR_REVIEW, "fef2c0"],
              [REJECTED, "e11d21"],
              [REVIEW_REQUESTED, "fef2c0"],
              [IN_PROGRESS, "1d76db"]].each do |label, color|
      begin
        client.add_label(repo_full_name, label, color)
      rescue Octokit::UnprocessableEntity
      end
    end
  end

  def handle_github(type, payload)
    @repo_full_name = payload["repository"]["full_name"]

    add_labels

    case type
    when "pull_request_review"
      handle_github_pull_request_review(payload)
    when "pull_request"
      handle_github_pull_request(payload)
    when "issues"
      handle_github_issues(payload)
    end
  end

  def handle_github_issues(payload)
    id = payload["issue"]["number"]

    if payload["action"] == "labeled"
      if payload.dig("label", "name") == READY_FOR_REVIEW
        remove_label(id, IN_PROGRESS)
      end

      if payload.dig("label", "name") == REJECTED
        remove_label(id, IN_PROGRESS)
        remove_label(id, READY_FOR_REVIEW)
      end

      if payload.dig("label", "name") == REVIEW_REQUESTED
        remove_label(id, IN_PROGRESS)
        add_label(id, READY_FOR_REVIEW)
      end
    end

    if payload["action"] == "closed"
      remove_label(id, IN_PROGRESS)
      remove_label(id, READY_FOR_REVIEW)
      remove_label(id, REVIEW_REQUESTED)
    end
  end

  def handle_github_pull_request(payload)
    if %w(opened edited closed reopened).include?(payload["action"])
      update_referenced_issues_desc(payload)

      if payload["action"] == "closed" && payload["pull_request"]["merged"].to_s == "true"
        close_referenced_issues(payload)
      end
    elsif payload["action"] == "review_requested"
      review_requested_issue(payload)
    end
  end

  def handle_github_pull_request_review(payload)
    if payload["review"]["state"] == "changes_requested"
      reject_issue(payload)
    elsif payload["review"]["state"] == "approved"
      remove_review_requested_issue(payload)
    end
  end

  private

  def remove_label(id, label)
    client.remove_label(repo_full_name, id, label) rescue Octokit::NotFound
  end

  def add_label(id, label)
    client.add_labels_to_an_issue(repo_full_name, id, [label])
  end

  def update_referenced_issues_desc(payload)
    number = payload["pull_request"]["number"]

    find_fixable_issue_ids(payload["pull_request"]["body"]).each do |id|
      issue = client.issue(repo_full_name, id)

      action = payload["action"]

      body = if action == "closed"
               remove_pr_reference(number, issue)
             else
               client.add_assignees(repo_full_name, id, [payload["pull_request"]["user"]["login"]])
               add_in_progress(issue)
               add_pr_reference(action, number, issue)
             end

      next unless body

      client.update_issue(repo_full_name, id, issue["title"], body)
    end
  end

  def add_in_progress(issue)
    return if issue['labels'].any? { |label| label['name'] == READY_FOR_REVIEW }

    add_label(issue['number'], IN_PROGRESS)
  end

  def close_referenced_issues(payload)
    find_fixable_issue_ids(payload["pull_request"]["body"]).each do |id|
      client.close_issue(repo_full_name, id)

      remove_label(id, READY_FOR_REVIEW)
      remove_label(id, REJECTED)
      remove_label(id, REVIEW_REQUESTED)
      remove_label(id, IN_PROGRESS)
    end
  end

  def remove_pr_reference(number, issue)
    body = issue["body"].to_s
    body.gsub("**PR:** ##{number}", "<strike>**PR:** ##{number}</strike>")
  end

  def add_pr_reference(action, number, issue)
    body = issue["body"].to_s

    body.gsub!("<strike>**PR:** ##{number}</strike>", "") if action == "reopened"

    return if body.include?("**PR:** ##{number}")

    body += "\n" unless body.include?("**PR:**")

    body += "\n**PR:** ##{number}"
  end

  def reject_issue(payload)
    find_fixable_issue_ids(payload["pull_request"]["body"]).each do |id|
      add_label(id, REJECTED)
    end
  end

  def review_requested_issue(payload)
    find_fixable_issue_ids(payload["pull_request"]["body"]).each do |id|
      add_label(id, REVIEW_REQUESTED)
    end
  end

  def remove_review_requested_issue(payload)
    find_fixable_issue_ids(payload["pull_request"]["body"]).each do |id|
      remove_label(id, REVIEW_REQUESTED)
    end
  end

  def find_fixable_issue_ids(body)
    fixes = body.scan(/(close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\s*(\#\d+|http.*\/\d+)/i)

    fixes.map!(&:last).map! do |issue|
      if issue.start_with?("#") # #7631"
        issue.sub("#", "")
      else
        issue.split("/").last # https://github.com/woodmont/spreeworks/issues/7631
      end
    end.uniq
  end
end
