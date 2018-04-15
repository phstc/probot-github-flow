class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :login, type: String
  field :company, type: String
  field :name, type: String
  field :access_token, type: String

  has_many :repositories
end
