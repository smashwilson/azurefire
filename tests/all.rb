# Run all unit tests defined within this directory.

require 'bundler/setup'

Dir[File.dirname(__FILE__) + "/*_test.rb"].each do |path|
  require_relative File.basename(path)
end
