class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :full_name, type: String
  field :private_repo, type: Boolean
  field :enabled, type: Boolean

  has_and_belongs_to_many :users
end
