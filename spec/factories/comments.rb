FactoryGirl.define do
  factory :comment do
    text "MyText"

    factory :comment_faq do
      commentable_type 'Faq'
    end
  end
end
