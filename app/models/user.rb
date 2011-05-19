# == Schema Information
# Schema version: 20110226055225
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :thoughts, :dependent => :destroy
  
#  EMAIL_STAFF_REGEX = /\A[\w+\-.]+@mail.blackburn.ac.uk/i
  email_regex = /\A[\w+\-.]+@+(blackburn.ac.uk|mail.blackburn.ac.uk)/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50}
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false}
                    
  validates :password, :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40}

  before_save :encrypt_password
  
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def feed
    Thought.all

  end


  
class << self
  def authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)

  end
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
 
    

  end
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}") 
  end

  def decrypt()
    
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

end
