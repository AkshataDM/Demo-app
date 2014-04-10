class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
 has_many :followed_users, through: :relationships, source: :followed
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
    has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
 def feed
    Micropost.from_users_followed_by(self)
  end
  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end

end
