APP_PATH = '/var/www/hunger-bot.datacrafts.io'

rails_env = ENV['RAILS_ENV'] || 'development'

worker_processes 5

working_directory APP_PATH + '/'

preload_app true

timeout 60

listen APP_PATH + '/shared/system/unicorn.sock', backlog: 64
pid APP_PATH + '/shared/pids/unicorn.pid'
stderr_path APP_PATH + '/shared/log/unicorn.stderr.log'
stdout_path APP_PATH + '/shared/log/unicorn.stdout.log'

before_exec do |server|
 ENV['BUNDLE_GEMFILE'] = APP_PATH + '/Gemfile'
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill(:QUIT, File.read(old_pid).to_i)
    rescue
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
