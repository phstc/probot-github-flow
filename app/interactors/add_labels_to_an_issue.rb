class AddLabelsToAnIssue
  include Interactor
  include InteractorHelper

  def_delegators :context, :repo_full_name, :number, :labels

  def call
    client.add_labels_to_an_issue(repo_full_name, number, labels)
  end
end
