FactoryGirl.define do

  factory :todo do
    title "Do something"
    completed false
    due_date { Date.tomorrow }
    priority 1
  end
end
