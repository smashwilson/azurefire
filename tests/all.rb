# Run all unit tests defined within this directory.

Dir[File.dirname(__FILE__) + "/*_test.rb"].each do |path|
  require path
end