FactoryGirl.define do
  factory :tag do
    name "my tag #{Time.now.to_i}"
  end
end
