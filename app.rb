require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end

  def authorize
    redirect '/signin' if current_user.nil?
  end
end

get '/' do
  redirect '/signin'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user=User.create(
  email:params[:email],
  password:params[:password],
  password_confirmation:params[:password_confirmation]
  )
  if @user.persisted?
    session[:user]=@user.id
    redirect '/home'
  end
  redirect '/signup'
end

get '/signin' do
  if !current_user.nil?
    redirect 'home'
  else
    erb :signin
  end
end

post '/signin' do
  user=User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user]=user.id
    redirect '/home'
  end
  redirect 'signin'
end

get '/signout' do
  session[:user]=nil
  redirect '/signin'
end

# get '/owners/signup' do
#   erb :signup
# end

# post '/owners/signup' do
#   user=User.create(
#     email: params[:email],
#     password: params[:password],
#     password_confirmation: params[:password_confirmation]
#   )
#   if user.persisted?
#     session[:user]=user.id
#     redirect '/store'
#   end
# end

# get '/owners/signin' do
#   erb :signin
# end

# post '/owners/signin' do
#   user=User.find_by(email: params[:email])
#   if user && user.authenticate(params[:password])
#     session[:user]=user.id
#     redirect '/store'
#   end
# end

# get '/owners/signout' do
#   session[:user]=nil
#   redirect '/owner/signin'
# end

get '/success' do
  authorize
  erb :success
end

get '/fail' do
  authorize
  erb :fail
end

get '/home' do
  authorize
  erb :home
end

post '/credit' do
  authorize
  redirect '/home'
end

get '/credit' do
  authorize
  erb :credit
end

get '/signout' do
  authorize
  erb :signout
end

post '/charge' do
  authorize
  user = current_user
  stored_value = params[:stored_value].to_i
  user.balance += stored_value
  user.save!
  redirect '/home'
end

get '/charge' do
  authorize
  erb :charge
end

get '/payment/owners' do
  authorize
  erb :payment
end

post '/payment/owners' do
  authorize
  redirect '/success'
end

 post '/store' do
  authorize
   redirect '/store'
 end

get '/store' do
  authorize
  @items=Item.all
  carts = Cart.where(user_id: current_user.id)
  puts carts
  @cart_count = 0
  carts.each do |cart|
    @cart_count += cart.count
  end
  puts @cart_count
  erb :store
end

post '/invoice' do
  authorize
  redirect '/store'
end

get '/payment' do
  authorize
  user = current_user
  @total=params[:total].to_i
  authorize
  if user.balance<@total
      redirect '/charge'
    else
      erb :payment
    end
end

post '/payment' do
  authorize
  user = current_user
  total=params[:total].to_i
    user.balance -= total
    user.save!
    redirect '/home'
end

get '/items/create' do
  authorize
  erb :item
end

post '/items/create' do
  authorize
  item=Item.create(
    name: params[:name],
    price: params[:price]
  )
  redirect '/items/create'
end

post '/carts/create/:item_id' do
 authorize
 cart = Cart.find_by(item_id: params[:item_id],user_id: current_user.id)
 if cart
  cart.count += 1
  cart.save!
 else
  new_cart = Cart.create(
   item_id: params[:item_id],
   user_id: current_user.id
 )
 new_cart.count += 1
  new_cart.save!
 end

 redirect '/store'
end

get '/cart' do
  authorize
  @carts = Cart.where(user_id: current_user.id)
  @items = []
  # @carts.each do |cart|
  #   items = @carts.where(item_id: cart.item_id)
  #   count = items.count

  #   item = {
  #     id: 1,
  #     name: "aa",
  #     count: 2,
  #     total: 240
  #   }
  #   @items.push(item)
  # end

  # @items = [
  #   {
  #     id: 1,
  #     name: "aa",
  #     count: 2,
  #     total: 240
  #   },
  # ]
  erb :cart
end

post '/invoice' do
  authorize
  user = current_user
  total=params[:total].to_i
    user.balance -= total
    user.save!
    redirect '/home'
end