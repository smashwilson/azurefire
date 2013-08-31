require 'spec_helper'

describe Settings do
  subject do
    Settings.load <<TEXT
{
  "post-dirs": ["foo", "bar", "baz"],
  "post-ext": "md",
  "data-root": "hurf",
  "public-root": "splug",
  "base-url": "http://huuuurf.org/",
  "qotd-paths": ["one.qotd", "two.qotd"]
}
TEXT
  end

  its(:post_dirs) { should == %w{foo bar baz} }
  its(:post_ext) { should == 'md' }
  its(:data_root) { should == 'hurf' }
  its(:public_root) { should == 'splug' }
  its(:base_url) { should == 'http://huuuurf.org/' }
  its(:qotd_paths) { should == %w{one.qotd two.qotd} }
end
