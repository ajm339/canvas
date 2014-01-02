# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
# Canvas::Application.config.secret_key_base = '6be54a6001f54d4d6d8413625831fe9bf2bcc385afc4f8a462bb8eb02b7f2b64df25583bf8aa62081c2310e0e78917a5f587bfe69f9637cffe9b6c6b77155f7b'
Canvas::Application.config.secret_key_base = ENV['SECRET_TOKEN']