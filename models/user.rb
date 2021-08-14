# Models
class User
  include Mongoid::Document
  has_many :posts

  field :name, type: String

  validates :name, presence: true
end
