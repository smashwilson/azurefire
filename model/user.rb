require_relative '../persistent'
require 'digest'

class User < Persistent
  directory 'user'
  
  attr_accessor :username, :password_hash
  key :username
  
  def == other
    username == other.username
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