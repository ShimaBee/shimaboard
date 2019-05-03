# shimaboard
simple board app by sinatra

## 動作環境
ruby 2.6.2
sinatra 2.0.5
sinatra-contrib 2.0.5
pg 1.1.4

## gem
```$ gem install sinatra sinatra-contrib pg```

## DB

DB作成<br>
```$ createdb shimaboard```

DBに入る<br>
```$ psql shimaboad```

posts tableを作る<br>
```create table posts (id serial primary key, title varchar(255), contents text, image text, user_id integer);```

users tableを作る<br>
```create table users (id serial primary key, name varchar(20), password varchar(30));```
