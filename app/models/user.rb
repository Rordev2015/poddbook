class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy
    has_many :user_friendships
    has_many :friends, -> { where(user_friendships: { state: 'accepted' }) }, through: :user_friendships
    
    has_many :pending_user_friendships,-> { where(user_friendships: {state: 'pending'})},class_name: "UserFriendship",foreign_key: "user_id" 
    has_many :pending_friends, through: :pending_user_friendships, source: :friend
    
    has_many :requested_user_friendships,-> { where(user_friendships: {state: 'requested'})},class_name: "UserFriendship",foreign_key: "user_id" 
    has_many :requested_friends, through: :requested_user_friendships, source: :friend
    
    has_many :blocked_user_friendships,-> { where(user_friendships: {state: 'blocked'})},class_name: "UserFriendship",foreign_key: "user_id" 
    has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
    
    has_many :accepted_user_friendships,-> { where(user_friendships: {state: 'accepted'})},class_name: "UserFriendship",foreign_key: "user_id" 
    has_many :accepted_friends, through: :accepted_user_friendships, source: :friend
    
    attr_accessor :remember_token, :activation_token , :reset_token
    
    before_save   :downcase_email
    before_create :create_activation_digest
    
    validates :f_name, presence: true, length: { maximum: 25 }
    validates :l_name, presence: true, length: { maximum: 25 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
    validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
    validates :city, presence: true, length: { maximum: 30 }
    validates :gender, presence: true, length: { maximum: 10 }
    validates :password, length: { minimum: 6 }, allow_blank: true
    has_secure_password
    
    # Returns the full_name of the user
    def full_name
       f_name + " " + l_name 
    end
    
    # Returns the hash digest of the given string. 
    def User.digest(string) 
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost) 
    end 
    
    # Returns a random token.
    def User.new_token
       SecureRandom.urlsafe_base64 
    end
    
    # Remmebers the user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Forgets a user.
    def forget
       update_attribute(:remember_digest, nil) 
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Activates an account.
    def activate
        update_attribute(:activated,true)
        update_attribute(:activated_at, Time.zone.now)
    end
    
    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
    
    # Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # Defines a proto-feed.
    # See "Following users" for the full implementation.
    def feed
        Micropost.where("user_id = ?", id)
    end
    
    def has_blocked?(other_user)
        blocked_friends.include?(other_user)
    end
    
    private
        # Converts email to all lower-case.
        def downcase_email
         self.email = email.downcase
        end
        
        # Creates and assigns the activation token and digest.
        def create_activation_digest
         self.activation_token = User.new_token
         self.activation_digest = User.digest(activation_token)
        end
end
