@app = "/home/ubuntu/ruby/hilios"

# Nuke workers after 30 seconds instead of 60 seconds (the default)
timeout           30
worker_processes  1
working_directory "#{@app}/current"

# Listen on fs socket for better performance
listen            "#{@app}/shared/sockets/unicorn.sock", backlog: 64

pid               "#{@app}/shared/pids/unicorn.pid"
stderr_path       "#{@app}/shared/log/unicorn.stderr.log"
stdout_path       "#{@app}/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Force the bundler gemfile environment variable to 
# reference the Сapistrano "current" symlink
before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(@app, 'Gemfile')
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
  
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  @old_pid = "#{@app}/shared/pids/unicorn.pid.oldbin"
  if File.exists?(@old_pid) && server.pid != @old_pid
    begin
      Process.kill("QUIT", File.read(@old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
 

