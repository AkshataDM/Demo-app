class User < ActiveRecord::Base
has_many :microposts, dependent: :destroy
 before_save { self.email = email.downcase }
  before_create :create_remember_token
validates :name, presence: true, length: { maximum: 50 }
validates :email, presence: true, uniqueness: true
validates :password, length: { minimum: 6 }

has_secure_password
 validates :password, length: { minimum: 6 }

def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end

end
