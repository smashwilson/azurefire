require 'fog'
require 'yaml'
require 'find'

FOG_CONFIG = 'fog.yml'

module AssetPublisher
  class Generator < Jekyll::Generator
    def generate(site)
      unless File.exist? FOG_CONFIG
        puts "No config."
        site.data['asset.url'] = site.data['site.url']
        return
      end

      puts "Publishing assets!"
      puts "Got the fog config!"
      @fog = YAML.load_file FOG_CONFIG

      @storage = Fog::Storage.new(
        provider: :rackspace,
        rackspace_username: @fog['account']['username'],
        rackspace_api_key: @fog['account']['api_key']
      )

      @directory = @storage.directories.new(@fog['container'])
      if @directory.nil?
        @directory = @storage.directories.create(key: @fog['container'])
      end

      @directory.public = true
      @directory.save

      # Upload each file listed in 'files'
      @fog['files'].each do |path|
        File.open(path) do |inf|
          @directory.files.create(key: path, body: inf)
        end
      end

      # Recursively upload each file listed in 'directories'
      @fog['directories'].each do |root|
        Find.find(root) do |path|
          next unless File.file?(path)

          File.open(path) do |inf|
            @directory.files.create(key: path, body: inf)
          end
        end
      end

      site.data['asset.url'] = @directory.public_url
    end
  end
end
