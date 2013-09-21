require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Precompile the scss templates into public/.'
task :sass do
  require 'sass'

  Dir[File.join(__dir__, 'views', '*.scss')].each do |in_path|
    out_path = File.join(__dir__, 'public', File.basename(in_path).gsub(/\.scss$/, '.css'))
    engine = Sass::Engine.new(File.read(in_path), :syntax => :scss)
    File.open(out_path, 'w') { |outf| outf.print(engine.render) }
  end
end
