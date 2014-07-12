require 'fog'
require 'yaml'
require 'find'
require 'pry'

FOG_CONFIG = '_fog.yml'

# Derive the asset base URL from a Cloud Files container.
#
module BaseUrl
  class Generator < Jekyll::Generator

    def generate(site)
      fog_yml = File.join(site.source, FOG_CONFIG)
      return unless File.exist? fog_yml

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

      site.assets_config.baseurl = @directory.public_url
    end
  end
end
