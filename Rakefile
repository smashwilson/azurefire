# Common build operations

desc 'Initialize the production database so that I can log in.'
task :bootstrap do
  require 'model/user'
  
  me = User.new
  me.username = 'smash'
  me.password = 'changeme'
  me.save
end

desc 'Execute all unit tests.'
task :test do
  require 'tests/all'
end