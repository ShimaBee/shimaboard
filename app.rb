require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'sinatra/cookies'
require 'pry'

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
  id = connection.exec("select id from users where name = $1 and password = $2",[name, password]).first
  if id
    session[:user_id] = id['id']
    redirect '/timeline'
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
  unless res
    connection.exec("insert into users (name, password) values($1, $2)",[name, password])
    redirect '/login'
  else
    redirect '/register'
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
  user_id = session[:user_id]
  title = params['title']
  contents = params['contents']
  FileUtils.mv(params['image']['tempfile'], "./public/images/#{params['image']['filename']}")
  connection.exec('insert into posts(title, contents, user_id, image) values($1, $2, $3, $4)', [title, contents ,user_id, params['image']['filename']])
  redirect '/timeline'
end

get '/mypage' do
  check_login
  user_id = session[:user_id]
  @user_name = connection.exec('select name from users where id = $1',[user_id]).first
  @res = connection.exec('select * from posts where user_id = $1',[user_id])
  erb :mypage
end

get '/delete/:id' do
  check_login
  connection.exec('delete from posts where id = $1',[params['id']])
  redirect '/mypage'
end

get '/edit/:id' do
  check_login
  @res = connection.exec('select * from posts where id = $1',[params['id']]).first
  @post_id = @res['id']
  erb :edit
end

post '/edit/:id' do
  title = params['title']
  contents = params['contents']
  id = params['id']
  FileUtils.mv(params['image']['tempfile'], "./public/images/#{params['image']['filename']}")
  connection.exec('update posts set title = $1, contents = $2, image = $3 where id = $4', [title, contents,params['image']['filename'], id])
  redirect '/mypage'
end
