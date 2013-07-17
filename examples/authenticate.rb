require 'rubygems'
require 'linkedin'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_consumer_key', 'your_consumer_secret')

# authorize from previously fetched access keys
c.authorize_from_access("OU812")

# you're now free to move about the cabin, call any API method
