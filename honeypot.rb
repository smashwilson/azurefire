# Module that implements functionality necessary for the comment-form honeypot fields.

require 'securerandom'
require 'digest'

module Honeypot

  TOKEN_PATH = '.secret'

  # Generate, or read, a secret token that will be used to validate form input.
  def secret
    return @honeypot_secret if @honeypot_secret
    if File.exist? TOKEN_PATH
      @honeypot_secret = File.read(TOKEN_PATH).strip
    else
      @honeypot_secret = SecureRandom.hex(64)
      File.open(TOKEN_PATH, 'w') { |f| f.print @honeypot_secret }
      @honeypot_secret
    end
  end

  # Create a SHA256 hash of the provided strings, concatenated. Used to
  # generate the spinner, field names, hidden field values, and other
  # such obfuscated entries.
  def hash *string
    Digest::SHA2.hexdigest(string.join)
  end

  # Create a value for the spinner field.
  def spinner ts, client_ip, slug
    hash ts, client_ip, slug, secret
  end

  # Build an obfuscated field name.
  def field_name spinner, human_name
    hash spinner, human_name, secret
  end

end
