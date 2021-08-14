# Models
class Rating
  include Mongoid::Document
  belongs_to :post

  #field :post_id, type: String
  field :ratings_total, type: Integer, default: 0
  field :average_rating, type: Float, default: 0.0
  field :total_number_of_ratings, type: Integer, default: 0

  validates :ratings_total, presence: true
  validates :average_rating, presence: true
  validates :total_number_of_ratings, presence: true
end
