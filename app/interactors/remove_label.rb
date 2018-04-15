class RemoveLabel
  include Interactor
  include InteractorHelper

  def_delegators :context, :repo_full_name, :number, :label

  def call
    client.remove_label(repo_full_name, number, label)
  rescue Octokit::NotFound
    # ignore if label not found
  end
end
