require_relative 'storage_test_case'
require_relative '../settings'

class SettingsTest < StorageTestCase

  def test_load_settings
    settings = Settings.load <<TEXT
{
  "post-dirs": ["foo", "bar", "baz"],
  "post-ext": "md",
  "data-root": "hurf"
}
TEXT
    assert settings.post_dirs == ['foo', 'bar', 'baz']
    assert settings.post_ext == 'md'
    assert settings.data_root == 'hurf'
  end

end
