# shimaboard
simple board app by sinatra

## gem
```$ gem install sinatra sinatra-contrib pg```

## create db

DB作成<br>
```$ createdb shimaboard```

DBに入る<br>
```$ psql shimaboad```

posts tableを作る<br>
```create table posts (id serial primary key, title varchar(255), contents text, image text, user_id integer);```

users tableを作る<br>
```create table users (id serial primary key, name varchar(20), password varchar(30));```
