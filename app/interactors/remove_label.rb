class RemoveLabel
  include Interactor
  include InteractorHelpers

  def call
    client.remove_label(context.repo_full_name, context.id, Array(context.label))
  end
end
