module InteractorHelpers
  def self.included(base)
    base.extend Forwardable
  end

  private

  def each_fixable_issue(body, &block)
    Webhooks::FindFixableIssues.call!(body: body).ids.each(&block)
  end

  def remove_label(id, label)
    RemoveLabel.call!(
      repo_full_name: context.repo_full_name,
      id: id,
      label: label,
      access_token: context.access_token
    )
  end

  def add_label_to_an_issue(id, label)
    AddLabelToAnIssue.call!(
      repo_full_name: context.repo_full_name,
      id: id,
      label: label,
      access_token: context.access_token
    )
  end

  def client
    @_client = Octokit::Client.new(access_token: context.access_token)
  end
end
