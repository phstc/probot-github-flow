class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  field :login, type: String
  field :name, type: String
  field :company, type: String
  field :email, type: String

  has_many :repositories
end
