See
- http://qiita.com/Yarimizu14/items/c81a8cf1859f954b953e
- https://gist.github.com/EvertonSilva/20e9295359a95cfd80f43d09031bcdaa
- https://www.commandercoriander.net/blog/2014/01/11/curling-with-rails/


    $ brew install jq
    $ gem install rails --version="~>4.2.0"

    $ rails new rails4_apiTokenAuthentication --api
    $ cd rails4_apiTokenAuthentication/

    $ bundle exec rails g scaffold Product name:string age:integer email:string
    $ bundle exec rake db:setup
    $ bundle exec rake db:migrate

    $ bundle exec rails s

create は CSRF token チェックをしている。次のコマンドはエラーが発生する。

    $ curl -X POST -H 'Content-Type:application/json' -d '{ "product": { "name": "test", "age": 10, "email": "test@example.com" }}' http://0.0.0.0:3000/products.json

CSRF token を指定する。
まず、 html ページにアクセスして、CSRF トークンを取得する。

    $ curl http://localhost:3000/products --cookie-jar cookie | grep csrf

cookie と CSRF token を指定すると、エラーが解消する。

    $ curl -b cookie -X POST  -d '{ "product": { "name": "test", "age": 10, "email": "test@example.com" }}' -H "X-CSRF-TOKEN: hhSi+sJIzA04hZIfMeLVzbQcFosD2cAM7/R6bs8lrW2CubUqH624jITHiQc2S6vK1WH154ni2fcCq199I5gTRA==" -H "Content-Type: application/json" http://localhost:3000/products.json

products_controller.rb 中の before_action :authenticate を有効にして、
Authorization token をチェックするようにする。

↑のコマンドは "HTTP Token: Access denied." のエラーが出るようになってしまう。
Authorization: Token を指定すると、エラーが解消する。

    $ curl -X POST -H 'Authorization: Token FOO' -H 'Content-Type:application/json' -d '{ "product": { "name": "test", "age": 10, "email": "test@example.com" }}' http://0.0.0.0:3000/products.json | jq . | less

DELETE メソッドも次のように呼び出せる。

    $ curl -b cookie -X DELETE  -H "X-CSRF-TOKEN: 83IX+kO9l0Ppw5JXkIe7AoOP5urKnDWdv88Bx8IsL2jGeTGVY60DIn7tBbUwtCWo/KEvdlnBsgf5pZYlvaYD8A==" -H 'Authorization: Token FOO' -H "Content-Type: application/json" http://localhost:3000/products/16.json

index は Authorization token チェックはしていない。

    $ curl -X GET -H 'Content-Type:application/json' http://0.0.0.0:3000/products.json | jq . | less


データ追加、一覧、削除を連続しておこなった様子を以下に示す。

    $ curl  -c cookie http://localhost:3000/products | grep csrf
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
    100  2467  100  2467    0     0  45815      0 --:--:-- --:--:-- --:--:-- 46547
    <meta name="csrf-param" content="authenticity_token" />
    <meta name="csrf-token" content="Bco9w8T7NKcFZTNWuFDvET8iZrp+GQ3rAoNpQwiWQiCsi3NV/wL+KIa4dwGVwK0S9wXBC0umyBXq5V62sM5E1g==" />

    $ curl -b cookie -X POST  -d '{ "product": { "name": "test", "age": 10, "email": "test@example.com" }}' -H "X-CSRF-TOKEN: Bco9w8T7NKcFZTNWuFDvET8iZrp+GQ3rAoNpQwiWQiCsi3NV/wL+KIa4dwGVwK0S9wXBC0umyBXq5V62sM5E1g==" -H 'Authorization: Token FOO' -H "Content-Type: application/json" http://localhost:3000/products.json
    {"id":2,"name":"test","age":10,"email":"test@example.com","created_at":"2017-04-13T15:37:35.906Z","updated_at":"2017-04-13T15:37:35.906Z","url":"http://localhost:3000/products/2.json"}

    $ curl  -c cookie http://localhost:3000/products.json
    [{"id":1,"name":"test","age":10,"email":"test@example.com","created_at":"2017-04-13T15:35:19.995Z","updated_at":"2017-04-13T15:35:19.995Z","url":"http://localhost:3000/products/1.json"},{"id":2,"name":"test","age":10,"email":"test@example.com","created_at":"2017-04-13T15:37:35.906Z","updated_at":"2017-04-13T15:37:35.906Z","url":"http://localhost:3000/products/2.json"}][katoy@katoy-MacBook-Pro rails4_apiTokenAu-b cookie -X DELETE  -H "X-CSRF-TOKEN: Bco9w8T7NKcFZTNWuFDvET8iZrp+GQ3rAoNpQwiWQiCsi3NV/wL+KIa4dwGVwK0S9wXBC0umyBXq5V62sM5E1g==" -H 'Authorization: Token FOO' -H "Content-Type: application/json" http://localhost:3000/products/1.json

    $ curl  -c cookie http://localhost:3000/products.json
    [{"id":2,"name":"test","age":10,"email":"test@example.com","created_at":"2017-04-13T15:37:35.906Z","updated_at":"2017-04-13T15:37:35.906Z","url":"http://localhost:3000/products/2.json"}]

    $ curl -b cookie -X DELETE  -H "X-CSRF-TOKEN: Bco9w8T7NKcFZTNWuFDvET8iZrp+GQ3rAoNpQwiWQiCsi3K0S9wXBC0umyBXq5V62sM5E1g==" -H 'Authorization: Token FOO' -H "Content-Type: application/json" http://localhost:3000/products/2.json

    $ curl  -c cookie http://localhost:3000/products.json
    []
