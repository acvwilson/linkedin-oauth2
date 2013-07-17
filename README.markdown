# LinkedIn

Ruby wrapper for the [LinkedIn API](http://developer.linkedin.com). Heavily inspired by [John Nunemaker's](http://github.com/jnunemaker) [Twitter gem](http://github.com/jnunemaker/twitter), the LinkedIn gem provides an easy-to-use wrapper for LinkedIn's Oauth2/XML APIs.

## Installation

    [sudo] gem install linkedin

## Usage

### Authenticate

LinkedIn's API uses Oauth2 for authentication. Luckily, the LinkedIn gem hides most of the gory details from you.

```ruby
require 'rubygems'
require 'linkedin'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_consumer_key', 'your_consumer_secret')

# authorize from previously fetched oauth2 access tokens
client.authorize_from_access("OU812")

# you're now free to move about the cabin, call any API method
```

### Profile examples
```ruby
# get the profile for the authenticated user
client.profile

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/asa.wilson')
```

If you want to play with the LinkedIn api without using the gem, have a look at the [apigee LinkedIn console](http://app.apigee.com/console/linkedin).

## TODO

* Implement Messaging APIs

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2013 Asa Wilson. See LICENSE for details.
