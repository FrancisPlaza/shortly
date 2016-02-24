# Shortly

Shortly is a micro service to shorten urls, in the style that TinyURL and bit.ly made popular.

We took Ruby off the Rails.  Don't tell Mom.  Shortly stores data in Postgresql, but without ActiveRecord (it uses the lightweight ORM Sequel instead). The API is served by Sinatra. Because Francis is lazy, we still load ActiveSupport.

## Setup

Shortly only speaks JSON.  Get yourself a browser extension that formats JSON nicely, or this won't be nearly as much fun for you as it was for us.

### 0. Install dependencies

If you don't already have them, install the following (perferably using homebrew):

* postgres

### 1. Clone the repo and install gems

```sh
git clone https://github.com/FrancisPlaza/shortly.git
bundle install
```

### 2. Set up the databases

```sh
cp config/database.yml.sample config/database.yml
createdb shortly_development
createdb shortly_test
```

If you have a non-standard setup, you may need to change some things in _config/database.yml_.

There is a database task to migrate your database.  This is a self-contained task that can migrate your database to the currently-required format.  It does not make use of the migrations you might be used to from ActiveRecord.  See _lib/tasks/db.rake_.

```sh
bundle exec rake db:migrate
```

__Note that this task does not automatically migrate your test database; you will need to explicity run this task with `RACK_ENV=test`.__

### 4. Start a web server

Pow works just fine.  Alternately, you can run `bundle exec rake server` which will instantiate a Puma webserver running at port 3000 by default.

### Running tests

You can run the RSpec tests by simply doing `rspec` in the root of the project.

### Console Access

`bundle exec rake console`

### Misc notes

use `RACK_ENV`, not `RAILS_ENV`