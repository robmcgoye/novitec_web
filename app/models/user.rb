class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  after_create do
    UserMailer.welcome_email(self).deliver_now
  end
end
