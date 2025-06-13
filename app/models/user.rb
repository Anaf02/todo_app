class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.authenticate(email, password)
    user = find_by(email: email.downcase)
    user if user&.valid_password?(password)
  end
end
