class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  validates :password, :presence => { :on => :create }
  validates :email, :presence => { :on => :create }, :uniqueness => { :case_sensitive => false }

  has_many :monsters, :dependent => :destroy
  has_many :tags, :dependent => :destroy
end
