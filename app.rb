require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'
require 'sinatra/cookies'

enable :sessions

# DB接続
connection = PG::connect(
  :host => "localhost", 
  :user => "shimabukuroyuuta", 
  :dbname => "shimaboard", 
  :port => 5432)

def check_login
    redirect '/login' unless session[:user_id]
end

get '/' do
  erb :index
end

get '/login' do
    erb :login
end

get '/logout' do
    session[:user_id] = nil
    redirect '/login'
end

post '/login' do
  name = params['name']
  password = params['password']
  res = connection.exec("select * from users where name = $1 and password = $2",[name, password]).first
  if res
    session[:user_id] = res['id']
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

get '/timeline' do
  @res = connection.exec('select * from posts')
  erb :timeline
end

get '/post' do
  check_login
  erb :post
end

post '/post' do
  title = params['title']
  contents = params['contents']
  FileUtils.mv(params['image']['tempfile'], "./public/images/#{params['image']['filename']}")
  connection.exec('insert into posts(title, contents, image) values($1, $2, $3)', [title, contents , params[:image][:filename]])
  redirect '/timeline'
end
