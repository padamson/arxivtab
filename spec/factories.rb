FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  # Usage
  # FactoryGirl.create(:url)
  # FactoryGirl.create(:url, :secure)
  # FactoryGirl.create(:url, subdomain: 'blog')
  # FactoryGirl.create(:url, path: '/about/us')
  # FactoryGirl.create(:arxiv, filename: '1411.237')

  factory :url, class: String do
    skip_create

    ignore do
      protocol 'http://'
      subdomain 'www'
      domain_name 'example.com'

      host { [subdomain, domain_name].compact.join('.') }
      port '80'

      path '/'
      filename ''
      extension ''
    end

    trait :secure do
      protocol 'https://'
      port nil
    end

    factory :arxiv do
      domain_name 'arxiv.org'
      port nil
      path '/pdf/'

      filename '1411.3717'
      extension '.pdf'
    end

    initialize_with { 
      new("#{protocol}#{[host, port].compact.join(':')}#{path}#{filename}#{extension}") }

  end

  factory :document do
    url
    user
  end

end
