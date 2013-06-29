# Run all unit tests defined within this directory.

require 'bundler/setup'

# Ensure that the tests always run in a consistent timezone.
ENV['TZ'] = 'UTC'

Dir[File.dirname(__FILE__) + "/*_test.rb"].each do |path|
  require_relative File.basename(path)
end
