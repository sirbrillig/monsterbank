class Monster < ActiveRecord::Base
  has_and_belongs_to_many :tags, :uniq => true
  # Destroy the tag if there are no more monsters.
  before_destroy { |monster| monster.tags.each {|tag| tag.destroy if tag.monsters.size == 1} }

  belongs_to :user
  scope :for_user, lambda { |user| joins(:user).where("user_id = ?", user.id) }

  attr_accessible :level, :name, :role, :subrole
  attr_accessible :str, :con, :dex, :int, :wis, :cha, :high_ability, :starred
  attr_accessible :speed

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false, :scope => :user_id }
  validates :role, :presence => true, :inclusion => { :in => [ 'Artillery', 'Brute', 'Controller', 'Lurker', 'Minion', 'Skirmisher', 'Soldier' ] }
  validates :subrole, :inclusion => { :allow_blank => true, :in => [ 'Elite', 'Solo' ] }
  validates :level, :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 31 }

  # will these work with the default accessors below?
  validates :str, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }
  validates :con, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }
  validates :dex, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }
  validates :int, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }
  validates :wis, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }
  validates :cha, :numericality => { :only_integer => true, :greater_than => -30, :less_than => 40 }

  # Unfortunately it appears that making default values for the ability scores
  # is not an easy thing. I added the reader accessors below but was forced to
  # add the setters as well for an unknown reason.
  def str=(val)
    @str = val
  end

  def con=(val)
    @con = val
  end

  def dex=(val)
    @dex = val
  end

  def int=(val)
    @int = val
  end

  def wis=(val)
    @wis = val
  end

  def cha=(val)
    @cha = val
  end

  def str
    @str || default_score_for(:str)
  end

  def con
    @con || default_score_for(:con)
  end

  def dex
    @dex || default_score_for(:dex)
  end

  def int
    @int || default_score_for(:int)
  end

  def wis
    @wis || default_score_for(:wis)
  end

  def cha
    @cha || default_score_for(:cha)
  end

  # Return the default Ability score.
  def default_score_for(abil)
    add = 13
    add = 16 if self.high_ability.to_s == abil.to_s
    return add if self.level.nil? # Edge cases where this is just a validation run
    add + (self.level / 2.0).floor
  end

  # Return the six ability scores as a Hash
  def ability_scores
    {:str => str, :con => con, :dex => dex, :int => int, :wis => wis, :cha => cha}
  end

  # Return the experience point value of this monster from level 1-30.
  #
  # It would be nice to do this by formula, but one does not exist within
  # reason.
  def xp
    base_xp = case self.level
    when 1 then 100
    when 2 then 125
    when 3 then 150
    when 4 then 175
    when 5 then 200
    when 6 then 250
    when 7 then 300
    when 8 then 350
    when 9 then 400
    when 10 then 500
    when 11 then 600
    when 12 then 700
    when 13 then 800
    when 14 then 1000
    when 15 then 1200
    when 16 then 1400
    when 17 then 1600
    when 18 then 2000
    when 19 then 2400
    when 20 then 2800
    when 21 then 3200
    when 22 then 4150
    when 23 then 5100
    when 24 then 6050
    when 25 then 7000
    when 26 then 9000
    when 27 then 11000
    when 28 then 13000
    when 29 then 15000
    when 30 then 19000
    else return 0
    # When editing, we now display the Monster, but the display will fail if
    # this exception is raised.
#     else raise "Level #{self.level} is not within a valid range for XP"
    end

    base_xp /= 4.0 if self.role == 'Minion'
    base_xp *=2 if self.subrole == 'Elite'
    base_xp *=5 if self.subrole == 'Solo'
    return base_xp.ceil
  end

  def hp
    multiplier = case self.role
    when 'Skirmisher' then 8
    when 'Brute' then 10
    when 'Soldier' then 8
    when 'Lurker' then 6
    when 'Controller' then 8
    when 'Artillery' then 6
    else 1
    end

    total = multiplier + (multiplier * self.level) + self.con
    total *= 2 if self.subrole == 'Elite'
    total *= 4 if self.subrole == 'Solo' # This isn't quite what the book says, but close enough.
    total
  end

  def bloodied
    (hp / 2.0).floor
  end

  def ac
    bonus = case self.role
    when 'Skirmisher' then 14
    when 'Brute' then 12
    when 'Soldier' then 16
    when 'Lurker' then 14
    when 'Controller' then 14
    when 'Artillery' then 12
    else 0
    end

    self.level + bonus
  end

  def reflex
    self.level + 12
  end

  def will
    self.level + 12
  end

  def fortitude
    self.level + 12
  end

  # This is again unecessary, except that adding the getter appears to require
  # adding the setter as well.
  def speed=(speed)
    @speed = speed
  end

  def speed
    @speed || 6
  end

end
