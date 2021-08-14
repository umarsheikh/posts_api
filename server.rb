require 'sinatra'
require 'mongoid'
require './models/user'
require './models/post'
require './models/rating'

# DB Setup
Mongoid.load! "mongoid.config"

# Endpoints
get '/ ' do
  'Welcome to BookList!'
end

get '/users' do
  User.all.to_json
end

get '/posts' do
  Post.all.to_json
end

get '/posts/ratings' do
  Rating.all.to_json
end

post '/posts' do
  params = JSON.parse(request.body.read)

  user_name = params['login']
  ip = request.env['REMOTE_ADDR']
  title = params['title']
  content = params['content']

  begin
    if user_name && title && content
      user = User.find_by(name: user_name)
      Post.create(title: title, content: content, user_id: user&.id, ip: ip).to_json
    else
      raise
    end

  rescue Mongoid::Errors::DocumentNotFound
    User.create(name: user_name)
    retry
  rescue
      response.status = 422
      "ERROR: Post title, content, and user name is required!"
  end
end

post '/posts/rating' do
  params = JSON.parse(request.body.read)
  id = params['id']
  value = params['value']

  begin
    if id && value
      post = Post.find(id)
    else
      raise
    end
  rescue Mongoid::Errors::DocumentNotFound
    response.status = 404
    "ERROR: post not found!"
  rescue
    response.status = 422
    "ERROR: Post ID and rating value is required!"
  end

  begin
    rating = Rating.find_by(post_id: post.id)
  rescue
    Rating.create(post_id: post.id)
    retry
  end

  rating.ratings_total +=  value
  rating.total_number_of_ratings += 1
  average = rating.ratings_total.to_f / rating.total_number_of_ratings
  rating.average_rating = average
  rating.save
end
