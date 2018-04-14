class RemoveLabel
  include Interactor
  include InteractorHelpers

  def_delegators :context, :repo_full_name, :number, :label

  def call
    client.remove_label(repo_full_name, number, Array(label))
  end
end
