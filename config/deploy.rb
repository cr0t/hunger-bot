require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_type,        :system
set :rvm_ruby_string, 'ruby-2.3.3@hunger-bot.datacrafts.io'

set :application, 'hunger-bot.datacrafts.io'

set :scm, :git
set :repository,  'https://github.com/cr0t/hunger-bot.git'
set :branch,      'master'

set :use_sudo,     false
set :user,         'daluboi' # username on the server
set :deploy_to,     "/var/www/#{application}"
set :keep_releases, 5
set :ssh_options,   { forward_agent: true }

server 'hunger-bot.datacrafts.io', :app, :web, :db, primary: true

# to use new assets approach
set :normalize_asset_timestamps, false

# unicorn related
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,  "#{deploy_to}/shared/pids/unicorn.pid"

namespace :deploy do
  after 'deploy', 'deploy:cleanup'

  desc 'Zero-downtime restart of Unicorn'
  task :restart do
   # run "sudo /etc/init.d/unicorn_#{application} restart"
     run "sudo /etc/init.d/unicorn restart"
  end

  task :start do
    run "sudo /etc/init.d/unicorn start"
  end

  task :stop do
    run "sudo /etc/init.d/unicorn stop"
  end
end
