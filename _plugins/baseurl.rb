require 'fog'
require 'yaml'
require 'find'

# Derive the asset base URL from a Cloud Files container.
#
module BaseUrl
  class Generator < Jekyll::Generator

    def generate(site)
      vars = %w{RACKSPACE_USERNAME RACKSPACE_APIKEY RACKSPACE_REGION RACKSPACE_CONTAINER}
      return if vars.any? { |v| ENV[v].nil? || ENV[v].empty? }

      @storage = Fog::Storage.new(
        provider: :rackspace,
        rackspace_username: ENV["RACKSPACE_USERNAME"],
        rackspace_api_key: ENV["RACKSPACE_APIKEY"],
        rackspace_region: ENV["RACKSPACE_REGION"],
        rackspace_cdn_ssl: true
      )

      @directory = @storage.directories.new(key: ENV["RACKSPACE_CONTAINER"])
      if @directory.nil?
        @directory = @storage.directories.create(key: ENV["RACKSPACE_CONTAINER"])
      end

      @directory.public = true
      @directory.save

      site.assets_config.baseurl = @directory.public_url
    end
  end
end
