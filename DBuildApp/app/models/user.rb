class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.from_omniauth(auth)
    identity = where(auth.slice(:provider, :uid)).first_or_create do |identity|
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.token = auth.credentials.token
      identity.secret = auth.credentials.secret if auth.credentials.secret
      identity.expires_at = auth.credentials.expires_at if auth.credentials.expires_at
      identity.email = auth.info.email if auth.info.email
      identity.image = auth.info.image if auth.info.image
      identity.first_name = auth.info.first_name
      identity.last_name = auth.info.last_name
    end
  end

  def find_or_create_user(current_user) 
    if current_user && self.email == current_user.email
      # User logged in and the identity is associated with the current user
      return self
    elsif current_user && self.email != current_user.email
      # User logged in and the identity is not associated with the current user so lets associate the identity and update missing info
      self.email ||= current_user.email
      self.skip_reconfirmation!
      self.save!
      return self
    else
      # No user associated with the identity so we need to create a new one
      self.save!(validate: false)
      return self
    end
  end
  
end
