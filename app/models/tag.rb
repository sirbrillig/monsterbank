class Tag < ActiveRecord::Base
  attr_accessible :name, :user

  has_and_belongs_to_many :monsters

  belongs_to :user
  scope :for_user, lambda { |user| joins(:user).where("user_id = ?", user.id) }

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false, :scope => :user_id }
end
