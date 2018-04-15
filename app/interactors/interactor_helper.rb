module InteractorHelper
  def self.included(base)
    base.extend Forwardable
  end

  private

  def each_fixable_issue(body, &block)
    Webhooks::FindFixableIssues.call!(body: body).numbers.each(&block)
  end

  def remove_label(number, labels)
    Array(labels).each do |label|
      RemoveLabel.call!(
        repo_full_name: context.repo_full_name,
        number: number,
        label: label,
        access_token: context.access_token
      )
    end
  end

  def add_labels_to_an_issue(number, label)
    AddLabelsToAnIssue.call!(
      repo_full_name: context.repo_full_name,
      number: number,
      label: label,
      access_token: context.access_token
    )
  end

  def client
    @_client = Octokit::Client.new(access_token: context.access_token)
  end
end
