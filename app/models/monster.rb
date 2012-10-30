class Monster < ActiveRecord::Base
  attr_accessible :level, :name, :role, :subrole

  def xp
    case self.level
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
      # FIXME: more levels
    else 101 # FIXME: some error, perhaps
    end
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
