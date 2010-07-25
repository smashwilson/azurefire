require 'digest'
require 'persistent'

class User < Persistent
  attr_accessor :username, :password_hash
  key :password_hash
  
  def initialize
    super
  end
  
  def password= password
    @password_hash = digest(password)
  end
  
  def has_password? password
    @password_hash == digest(password)
  end
  
  def digest plaintext
    Digest::SHA2.hexdigest(plaintext)
  end
end