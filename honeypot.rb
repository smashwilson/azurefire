# Module that implements functionality necessary for the comment-form honeypot fields.

require 'securerandom'

module Honeypot

  TOKEN_PATH = '.secret'

  # Generate, or read, a secret token that will be used to validate form input.
  def secret
    if File.exist? TOKEN_PATH
      File.read(TOKEN_PATH).chomp
    else
      secret = SecureRandom.hex(64)
      File.open(TOKEN_PATH, 'w') { |f| f.print secret }
      secret
    end
  end

end
