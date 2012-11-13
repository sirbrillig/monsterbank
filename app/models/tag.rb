class Tag < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :monsters
  attr_accessible :name, :user

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false, :scope => :user_id }
end
