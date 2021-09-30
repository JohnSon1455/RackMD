class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :notes, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :collected_notes, through: :collections, source: :note, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorite_notes, through: :likes, source: :note, dependent: :destroy
  has_many :comments, dependent: :destroy
  def favorite?(n)
    favorite_notes.exists?(n.id)
  end

  def collection?(n)
    collected_notes.exists?(n.id)
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
