
  $ gem install rails --version="~>4.2.0"
  $ rails new rails4_apiTokenAuthentication --api
  $ cd rails4_apiTokenAuthentication/

See http://qiita.com/Yarimizu14/items/c81a8cf1859f954b953e

  $ bundle exec rails g scaffold Product name:string age:integer email:string
  $ bundle exec rake db:setup
  $ bundle exec rake db:migrate
