FactoryGirl.define do
  factory :monster do
    name "testmonster_#{Time.now.to_i}"
    level 1
    role 'Artillery'
  end
  
  factory :level1_artillery, class: Monster do
    name "level1_artillery_#{Time.now.to_i}"
    level 1
    role 'Artillery'
  end

  factory :level1_soldier, class: Monster do
    name "level1_soldier_#{Time.now.to_i}"
    level 1
    role 'Soldier'
  end

  factory :level2_artillery, class: Monster do
    name "level2_artillery_#{Time.now.to_i}"
    level 2
    role 'Artillery'
  end

  factory :level1_elite_artillery, class: Monster do
    name "level1_elite_artillery_#{Time.now.to_i}"
    level 1
    role 'Artillery'
    subrole 'Elite'
  end
end
