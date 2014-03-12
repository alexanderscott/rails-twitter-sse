# TwitterSocketStreaming
An exercise in Rails 4 streams, SSEs, threads, Twitter Streaming API, and Redis Pub/Sub.


# About
* A Twitter Streaming API worker runs in a separate thread and publishes JSON serialized tweets via Redis.  
* When a new user logs in via Twitter OAuth, this Streaming thread adds their ID to the following pool and restarts. 
* A logged in client may make a connection using the browser's EventSource class to Server-Sent Events sent by the app server.
* A Redis pub-sub messaging broker mediates the communication between the server-side streaming worker/publisher and the client.  
* Basic user data is stored in Redis hashes and z-sets.  Tweets are not stored, but simply pass thru.


# Install & Run
Pull down Redis from your favorite package manager if you don't already have it installed.

Create an app on the [Twitter Developers](https://dev.twitter.com/) website and grant OAuth access 
to your account (needed for the Streaming API).

Clone this repo and update the `config/environment.yml` (included but blank) with your app access info. 

To run if your RAILS_ENV is set to development:

  
     $ bundle install
     # rake rails:update:bin
     $ rails s


Visit http://localhost:3000 in your browser.

If your RAILS_ENV=production, you may first need to precompile the assets with:


    RAILS_ENV=production bundle exec rake assets:precompile



# TODO
* Write tests

# LICENSE
The MIT License (MIT)

Copyright (c) 2014 Alex Ehrnschwender

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
