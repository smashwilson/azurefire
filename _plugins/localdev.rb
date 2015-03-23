# Wipe out the site.url setting if I'm developing locally.
module BaseUrl
  class Generator < Jekyll::Generator
    def generate(site)
      vars = %w{RACKSPACE_USERNAME RACKSPACE_APIKEY RACKSPACE_REGION RACKSPACE_CONTAINER}
      site.config['url'] = nil unless vars.any? { |v| ENV[v].nil? || ENV[v].empty? }
    end
  end
end
