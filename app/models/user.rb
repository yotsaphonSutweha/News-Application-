class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile
    # PASSWORD_REQUIREMENTS = /\A 
    #     (?=.{8,}) # At least 8 characters
    #     (?=.*\d) # Contain at least one number
    #     (?=.*[a-z]) # Contain at least one lowercase character
    #     (?=.*[A-Z]) # Contain at least one uppercase character
    # /x

    # validates :username, presence: true, length: {maximum: 15}
    # validates :encrypted_password, presence: true, confirmation: true
    # validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
end
