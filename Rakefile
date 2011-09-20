# Common build operations

desc 'Discover and preprocess all news posts.'
task :bake do
  require_relative 'bakery/baker'

  b = Baker.new
  b.bake! do |p|
    slug = p.meta ? p.meta.slug : 'error'
    puts "Baking [#{slug}]: [#{p.current} / #{p.total}]"
  end

  # Report any posts that produced errors.
  unless b.errors.empty?
    $stderr.puts "\nERRORS\n"
    b.errors.each do |e|
      $stderr.puts " - #{e.reason}"
    end
  end
end

desc 'Execute all unit tests.'
task :test do
  require_relative 'tests/all'
end
