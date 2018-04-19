class CreateRepository
  include Interactor
  include InteractorHelper

  def_delegators :context, :user, :full_name

  def call
    context.access_token = user.access_token

    repo_hash = client.repo(full_name)

    repo = Repository.where(full_name: context.full_name).first_or_initialize

    repo.name = repo_hash['name']
    repo.private_repo = repo_hash['private']
    repo.enabled = true
    repo.owner = user

    repo.save

    user.repositories << repo
    user.save
  end
end
