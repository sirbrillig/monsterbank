class Monster < ActiveRecord::Base
  attr_accessible :level, :name, :role, :subrole

  validates :name, :presence => true
  validates :role, :presence => true, :inclusion => { :in => [ 'Artillery', 'Brute', 'Controller', 'Lurker', 'Minion', 'Skirmisher', 'Soldier' ] }
  validates :subrole, :inclusion => { :allow_blank => true, :in => [ 'Elite', 'Solo' ] }
  validates :level, :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 31 }

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
    else raise "Level #{self.level} is not within a valid range for XP"
    end

    base_xp /= 4.0 if self.role == 'Minion'
    base_xp *=2 if self.subrole == 'Elite'
    base_xp *=5 if self.subrole == 'Solo'
    return base_xp.ceil
  end

  def hp
    case self.role
    when 'Soldier' then hp_by_level[self.level][:high]
    end
  end

  def hp_by_level
    {
      1 => { low: 24, medium:30, high:38 },
      2 => { low: 30, medium:38, high:48 },
      3 => { low: 36, medium:46, high:58 },
    }
  end
end
