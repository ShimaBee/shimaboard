# shimaboard
simple board app by sinatra

## versions
ruby 2.6.2<br>
sinatra 2.0.5<br>
sinatra-contrib 2.0.5<br>
pg 1.1.4<br>

## gem
```$ gem install sinatra sinatra-contrib pg```

## DB

DB作成<br>
```$ createdb shimaboard```

DBに入る<br>
```$ psql shimaborad```

posts tableを作る<br>
```create table posts (id serial primary key, title varchar(255), contents text, image text, user_id integer);```

users tableを作る<br>
```create table users (id serial primary key, name varchar(20), password varchar(30));```
