# Wipe out the site.url setting if I'm developing locally.
module BaseUrl
  class Generator < Jekyll::Generator
    def generate(site)
      site.config['url'] = nil unless File.exist?(File.join(site.source, FOG_CONFIG))
    end
  end
end
