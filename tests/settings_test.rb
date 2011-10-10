require_relative 'storage_test_case'
require_relative '../settings'

class SettingsTest < StorageTestCase

  def test_load_settings
    settings = Settings.load <<TEXT
{
  "post-dirs": ["foo", "bar", "baz"],
  "post-ext": "md",
  "data-root": "hurf",
  "public-root": "splug",
  "base-url": "http://huuuurf.org/",
  "qotd-paths": ["one.qotd", "two.qotd"]
}
TEXT
    assert_equal %w{foo bar baz}, settings.post_dirs
    assert_equal 'md', settings.post_ext
    assert_equal 'hurf', settings.data_root
    assert_equal 'splug', settings.public_root
    assert_equal 'http://huuuurf.org/', settings.base_url
    assert_equal %w{one.qotd two.qotd}, settings.qotd_paths
  end

end
