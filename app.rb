require 'sinatra'
require 'sinatra/reloader'
require 'pg'

enable :sessions

connection = PG::connect(
  :host => "localhost", 
  :user => "shimabukuroyuuta", 
  :dbname => "shimaboard", 
  :port => 5432)

def login_check
    redirect '/login' unless session[:user_id]
end

get '/' do
  @res = connection.exec('select * from users')
  @res.each do |user|
    p user['name']
  end
  erb :index
end

get '/login' do
    erb :login
end

post '/login' do
  name = params['name']
  password = params['password']
  connection.exec("select * from users where name = $1 and password = $2",[name, password]).first
  if res
    session[:user_id] = res['id']
    session[:name] = res['name']
    session[:password] = res['password']
    redirect '/'
  else
    redirect '/login'
  end
end

get '/register' do
    erb :register
end

post '/register' do
    name = params['name']
    password = params['password']
    res = connection.exec("select * from users where name = $1 and password = $2",[name, password]).first
  if res
    redirect '/register'
  else
    connection.exec("insert into users (name, password) values($1, $2)",[name, password])
    redirect '/'
  end
end
