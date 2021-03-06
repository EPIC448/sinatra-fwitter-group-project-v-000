class UsersController < ApplicationController

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/signup' do

    if !logged_in?
      erb :'users/create_user', locals: {message: "Please sign up before you sign in"}
    else
      redirect to '/tweets'
    end
  end

  post '/signup' do

    if params[:username] == "" || params[:email] == "" || params[:password] == ""

      redirect to '/signup'

    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    end
  end


  # >>>>>Log in part<<<

  # Dummy log in data   "username"=>"becky567", "password"=>"kittens"

  get '/login' do

    if !logged_in?
      erb :'/users/login'

    else
      redirect '/tweets'  #tweets control

    end
  end


  #session goes here.

  post '/login' do
    #handles logged in input of user from the params / Match that infor
    # with existing entries in the user database.
    user = User.find_by(:username => params[:username])  # Take name to get users  name
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else
      redirect to '/signup'
    end
  end


  get '/logout' do

    if !logged_in?
      redirect '/'
    else
      # log user out by clearing the session

      session.clear
      redirect to "/login"
    end
  end


  get "/users/:slug" do

    @user = User.find_by_slug(params[:slug])

    erb :'/users/show'

  end

end  #End for class method.
