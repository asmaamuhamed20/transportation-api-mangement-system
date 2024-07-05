FactoryBot.define do
    factory :user do
      email { 'test@example.com' }
      password { 'password' }
      password_confirmation { 'password' }
      username { 'test_user' }
    end
  end
  