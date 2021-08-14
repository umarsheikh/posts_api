# Models
class Post
  include Mongoid::Document
  has_one :rating
  belongs_to :user

  #field :user_id, type: String
  field :title, type: String
  field :content, type: String
  field :ip, type: String

  validates :title, presence: true
  validates :content, presence: true
  validates :ip, presence: true

end
