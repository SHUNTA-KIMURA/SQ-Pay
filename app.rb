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

# get '/payment/owners' do
#   authorize
#   erb :payment
# end

# post '/payment/owners' do
#   authorize
#   redirect '/success'
# end

 post '/store' do
  authorize
   redirect '/store'
 end

get '/store' do
  authorize
  @items=Item.all
  payments = Payment.where(user_id: current_user.id)
  payment = payments.last
  if payment
    carts =Cart.where(user_id: current_user.id).where('updated_at >= ?', payment.updated_at)
  else
    carts =Cart.where(user_id: current_user.id)
  end
  @cart_count = 0
  carts.each do |cart|
    @cart_count += cart.count
  end
  erb :store
end

get '/payment/:owner_id' do
  authorize
  user = current_user
  @owner_id = params[:owner_id].to_i
  payment = Payment.find_by(user_id: @owner_id, completed: false)
  @total = payment.total
  if user.balance<@total
    redirect '/charge'
  else
    erb :payment
  end
end

post '/payment/:owner_id' do
  authorize
  user = current_user
  @owner_id = params[:owner_id].to_i
  payment = Payment.find_by(user_id: @owner_id, completed: false)
  user.balance -= payment.total
  user.save!
  UserPayments.create(
    user_id: current_user.id,
    payment_id: payment.id
  )
  payment.completed = true
  payment.save!
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
  cart = Cart.find_by(item_id: params[:item_id], user_id: current_user.id, completed: false)
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
  @carts = Cart.where(user_id: current_user.id, completed: false)
  @purchases = []
  @all_total = 0
  @carts.each do |cart|
    item = Item.find_by(id: cart.item_id)
    data = {
      name: item.name,
      price: item.price,
      count: cart.count,
      total: item.price*cart.count
    }
    @all_total += data[:total]
    @purchases.push(data)
  end
  erb :cart
end

post '/invoice' do
  authorize
  carts = Cart.where(user_id: current_user.id, completed: false)
  all_total = 0
  carts.each do |cart|
    item = Item.find_by(id: cart.item_id)
    all_total += item.price*cart.count
  end
  payment=Payment.find_by(user_id: current_user.id, completed: false)
  unless payment
    current_user.payments.create(
      total: all_total
    )
  end
  redirect '/store'
end