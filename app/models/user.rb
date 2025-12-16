class User < ApplicationRecord
  ROLES = %w[client freelancer admin].freeze

  #Encryption for password
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  #Client
  has_many :projects, foreign_key: :client_id, dependent: :destroy

  #Freelancer
  has_many :proposals, foreign_key: :freelancer_id, dependent: :destroy
  has_many :portfolio_items, foreign_key: :freelancer_id, dependent: :destroy

  #Skills
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  #Reviews
  has_many :reviews_written, class_name: 'Review', foreign_key: :reviewer_id, dependent: :destroy
  has_many :reviews_received, class_name: 'Review', foreign_key: :reviewee_id, dependent: :destroy

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, uniqueness: true
  validates :password, 
    length: { minimum: 8, maximun: 64 },
    format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/, 
    message: 'must include at least one uppercase letter, one lowercase letter, one digit, and one special character' 
    },
    allow_nil: true

  #Helper methods for roles

  def client?
    role == 'client'
  end
  
  def freelancer?
    role == 'freelancer'
  end
  
  def admin?
    role == 'admin'
  end

  #set default role for safety
  after_initialize :set_default_role, if: :new_record?


  private

  def set_default_role
    self.role ||= 'client'
  end
end
