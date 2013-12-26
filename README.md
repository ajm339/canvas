canvas
======

Changing the way people think about work

# Technical
Code documentation in the wiki
* Ruby 2.0
* Rails 4.0.2
* Backbone

## Get started
RailsInstaller is outdated. Start with [RVM](http://rvm.io/). Get the latest version, and you can install with Ruby (instructions on that page). Then `gem install rails` or `gem update rails` to get Rails 4.

Get the [Postgres app](http://postgresapp.com/), which runs the database. 

Clone the repo from Github (I'd recommend the [Github app](http://mac.github.com/)). In Terminal, `cd` to the folder you clone to. Run `rake db:create:all` to set up the database. Run `bundle` to get the gems our project uses, then run `rails s` to start the server, and visit `localhost:3000` in your browser.

In development, I use LiveReload, which automatically refreshes the page when you save HTML or JS so you don't have to click back and forth, and makes CSS changes (when you save) without even having to refresh. This still works with SCSS and Coffeescript. Livereload is a browser extension for [Chrome](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en) and [Safari](http://download.livereload.com/2.0.9/LiveReload-2.0.9.safariextz). Open a new tab in Terminal (`Command-T`), then run `guard`. Click the LiveReload button in the browser toolbar, and it should turn black in the middle to show that it's active.