See
- http://qiita.com/Yarimizu14/items/c81a8cf1859f954b953e
- https://gist.github.com/EvertonSilva/20e9295359a95cfd80f43d09031bcdaa
- https://www.commandercoriander.net/blog/2014/01/11/curling-with-rails/
- http://qiita.com/mats116/items/5e2e8424a3d0c939eb11
- http://morizyun.github.io/blog/garage-gem-ruby-restful-hypermedia-api/
- https://github.com/doorkeeper-gem/doorkeeper
- https://www.codeschool.com/blog/2014/02/03/token-based-authentication-rails/
- http://railscasts.com/episodes/352-securing-an-api?language=ja&view=asciicast
- https://rubyplus.com/articles/4311-Securing-an-API-in-Rails-5-using-Token-Based-Authentication


    $ brew install jq
    $ gem install rails --version="~>4.2.0"

    $ rails new rails4_apiTokenAuthentication --api
    $ cd rails4_apiTokenAuthentication/

    $ bundle exec rails g scaffold Product name:string age:integer email:string
    $ bundle exec rake db:setup
    $ bundle exec rake db:migrate

    $ bundle exec rails s

アクセストークンを得る API は basic 認証をかけている。
    $ curl -X GET -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/auth.json?id=2
    HTTP Basic: Access denied.

    $ curl -X GET -H 'Content-Type:application/json' -u 'admin:secret' http://0.0.0.0:3000/api/v1/auth.json?id=2
    {"access_token":"b902f1e2235d3e79c2cf01fbeec48b3f"}

取得した access_token を header に設定して、shiow, update 操作ができる。

    $ curl -X GET -H 'Authorization: Token token="b902f1e2235d3e79c2cf01fbeec48b3f"' -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/show
    {"product":{"id":2,"name":null,"age":null,"email":null},"status":"200"}

    $ curl -X GET -H 'Authorization: Token token="b902f1e2235d3e79c2cf01fbeec48b3f"' -H 'Content-Type:application/json' -d '{ "product": { "name": "test", "age": 10, "email": "test@example.com" }}' http://0.0.0.0:3000/api/v1/update
    {"product":{"id":2,"name":"test","age":10,"email":"test@example.com"},"status":"200"}

    $ curl -X GET -H 'Authorization: Token token="b902f1e2235d3e79c2cf01fbeec48b3f"' -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/index.json
    {"products":[{"id":1,"name":"333","age":33,"email":"333@example.com"},{"id":2,"name":"test","age":10,"email":"test@example.com"}],"status":"200"}

アクセストークンを無効にする。
    $ curl -X GET -H 'Authorization: Token token="b902f1e2235d3e79c2cf01fbeec48b3f"' -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/unauth
    {"status":200}

再度、アクセストークンを取得すると、新たなトークン値が返ってくる、
    $ curl -X GET -H 'Content-Type:application/json' -u 'admin:secret' http://0.0.0.0:3000/api/v1/auth.json?id=2
    {"access_token":"06c433122f5d5e52e07551801d24091e"}
