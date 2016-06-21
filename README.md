# Seraph Grape integration
[![Build Status](https://secure.travis-ci.org/Szeliga/seraph-grape.svg?branch=master)](https://travis-ci.org/Szeliga/seraph-grape)
[![Code Climate](https://codeclimate.com/github/Szeliga/seraph-grape/badges/gpa.svg)](https://codeclimate.com/github/Szeliga/seraph-grape)
[![Test Coverage](https://codeclimate.com/github/Szeliga/seraph-grape/badges/coverage.svg)](https://codeclimate.com/github/Szeliga/seraph-grape/coverage)

[Seraph](https://github.com/Szeliga/seraph) helpers for Grape. Provides several simple helpers for implementing a JWT token authentication.

A sample usage in Grape can be found in [DummyApi Grape Endpoint](spec/support/dummy_api.rb).

Just like Seraph, this integration doesn't make any assumptions about your stuck. It does however make a small assumption about the authenticated User resource. It requires that this resource responds to two messages - `id` and `encrypted_password`. This is required for authentications and generating of JWT tokens. This resource can be anything from a `Struct`, `OpenStruct` to an `ActiveRecord` model.

For more information on what Seraph offers, visit the [projects repo](https://github.com/Szeliga/seraph).

## Installation

Enter in your terminal
```
gem install seraph-grape
```
or put
``` ruby
gem 'seraph-grape'
```
inside your `Gemfile`

## Configuration

In addition to the configuration fields that [Seraph](https://github.com/Szeliga/seraph#configuration) provides, the Seraph Grape integration gem adds another option called `api_secret`. This option is used by the JWT library as a secret passed to the hashing algorithm (HS256) to encode the token. **It is strongly recommended that this is set!**

``` ruby
Seraph.configure do |config|
  config.api_secret = 'GENERATED-SECRET'
end
```

The secret can be generated in the same manner, the pepper is generated in [Seraph](https://github.com/Szeliga/seraph#configuration).

## What do you get?

The library provides several things.

### Grape helpers

1. `authenticate!` - checks the `Authorization` header of the incoming request for a JWT token, if it finds a non-emtpy string in the header, it attempts to decode the token. If the decoding fails, a 401 error is returned instead.
2. `auth_info` - contains the `user_id` to whom the token was issued. Returns a Hash of the form `{ user_id: 1 }`.
3. `sign_in(user, password)` - takes a user resource (previously found by the e-mail, or other login information, posted to the sign in endpoint), and a plaintext password (also provided in the information posted to the sign in endpoint). Checks if the plaintext password matches the encrypted one in the `user` resource, using [Seraph's Password Comparator class](https://github.com/Szeliga/seraph#comparing-a-provided-password-with-the-encrypted-one). If the passwords match, it returns a JWT token for that `user` (using it's `id` method). If they do not, it raises a 401 error.

### Authenticator

The integration offers also `Seraph::Grape::Authenticator`. The `sign_in` Grape helper delegates to this class in order to do the authentication, as described above. You can invoke the class like this:

``` ruby
Seraph::Grape::Authenticator.call(user, password)
```

As stated above, if the passwords match, it returns a JWT token for the passed in `user`. If they do not, false is returned instead.

**Note** - this class will be probably moved to Seraph core in the near future, as it isn't grape-specific and could be used in other setups (`rails-api` for example).

## Roadmap

### Version 1.0.0
* move out `Seraph::Grape::Authenticator` to the core gem
* expose basic JWT options via configuration - algorithm, etc.
* implement JWT token [Expiration Time Claim](https://github.com/jwt/ruby-jwt#expiration-time-claim)
* implement JWT [Subject Claim](https://github.com/jwt/ruby-jwt#subject-claim) alongside subject verification option for decoding

## Copyright

Copyright (c) 2016 Szymon Szeliga

See LICENSE.txt for details.
