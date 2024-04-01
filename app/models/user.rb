class User < ApplicationRecord
   validates :name, presence: true
   validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
   validates :password, presence: true
   validates :password_digest, presence: true

   has_secure_password

   has_many :user_parties
   has_many :viewing_parties, through: :user_parties

   def self.all_but(id)
      User.where.not("users.id = ?", id)
   end

   def movie_ids
      viewing_parties.map(&:movie_id).uniq
   end
end
