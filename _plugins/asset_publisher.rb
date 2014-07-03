require 'fog'
require 'yaml'
require 'find'

FOG_CONFIG = '_fog.yml'

module AssetPublisher
  class Generator < Jekyll::Generator
    def generate(site)
      fog_yml = File.join(site.source, FOG_CONFIG)

      unless File.exist? fog_yml
        site.config['asset'] = { 'url' => site.config['url'] }
        return
      end

      @fog = YAML.load_file fog_yml

      @storage = Fog::Storage.new(
        provider: :rackspace,
        rackspace_username: @fog['account']['username'],
        rackspace_api_key: @fog['account']['api_key'],
        rackspace_region: @fog['account']['region'],
        rackspace_cdn_ssl: true
      )

      @directory = @storage.directories.new(key: @fog['container'])
      if @directory.nil?
        @directory = @storage.directories.create(key: @fog['container'])
      end

      @directory.public = true
      @directory.save

      print "Publishing static assets: "

      # Upload each file listed in 'files'
      (@fog['files'] || []).each do |path|
        File.open(File.join site.source, path) do |inf|
          @directory.files.create(key: path, body: inf)
          print '.'
        end
      end

      # Recursively upload each file listed in 'directories'
      (@fog['directories'] || []).each do |root|
        Find.find(File.join site.source, root) do |fullpath|
          next unless File.file?(fullpath)
          relpath = fullpath[(site.source.size + 1)..-1]

          File.open(fullpath) do |inf|
            @directory.files.create(key: relpath, body: inf)
            print '.'
          end
        end
      end

      puts

      site.config['asset'] = { 'url' => @directory.public_url }
    end
  end
end
