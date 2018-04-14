class AddLabelToAnIssue
  include Interactor
  include InteractorHelpers

  def call
    client.add_labels_to_an_issue(context.repo_full_name, context.id, [context.label])
  end
end
