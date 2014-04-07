require 'factory_girl'

FactoryGirl.define do
  factory :book, class: Bible::Book do
    name 'Genesis'
  end
end
