SpreeSmspay
===========

[SMSpay](http://docs.smspay.io/): A mobile friendly payment method implemented in Spree Commerce. 

Installation
------------

Add spree_smspay to your Gemfile:

```ruby
gem 'spree_smspay'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_smspay:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_smspay/factories'
```

Copyright (c) 2015 [Frontkom](https://www.frontkom.no/), released under the New BSD License
