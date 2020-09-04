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
  password_confirmation:params[:password_confirmation],
  balance:0
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

get '/owners/signup' do
  erb :signup
end

post '/owners/signup' do
  user=User.create(
    email: params[:email],
  password: params[:password],
  password_confirmation: params[:password_confirmation]
  )
  if user.persisted?
    session[:user]=user.id
    redirect '/store'
  end
end

get '/owners/signin' do
  erb :signin
end

post '/owners/signin' do
  user=User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user]=user.id
    redirect '/store'
  end
end

get '/owners/signout' do
  session[:user]=nil
  redirect '/owner/signin'
end

get '/success' do
  if !current_user.nil?
    erb :success
  else
    redirect '/signin'
  end
end

get '/fail' do
  if !current_user.nil?
    erb :fail
  else
    redirect '/signin'
  end
end

get '/home' do
  if !current_user.nil?
    erb :home
  else
    redirect '/signin'
  end
end

post '/credit' do
    redirect '/home'
end

get '/credit' do
  if !current_user.nil?
    erb :credit
  else
    redirect '/signin'
  end
end

get '/signout' do
  erb :signout
end

post '/charge' do
  user = current_user
  stored_value = params[:stored_value].to_i
  user.balance += stored_value
  user.save!
  redirect '/home'
end

get '/charge' do
  if !current_user.nil?
    erb :charge
  else
    redirect '/signin'
  end
end

get '/payment/owners' do
  if !current_user.nil?
    erb :payment
  else
    redirect '/signin'
  end
end

post '/payment/owners' do
  if !current_user.nil?
    redirect '/success'
  else
    redirect '/signin'
  end
end

post '/store' do
    redirect '/store'
end

get '/store' do
  if !current_user.nil?
    erb :store
  else
    redirect '/signin'
  end
end

get '/cart' do
  if !current_user.nil?
    erb :cart
  else
    redirect '/signin'
  end
end

post '/invoice' do
    redirect '/store'
end