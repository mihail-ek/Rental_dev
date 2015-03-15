FactoryGirl.define do
  factory :faq do
    ignore do
      current_user nil
    end

    after(:create) do |faq, evaluator|
      user = evaluator.current_user || create(:user)
      faq.comments = create(:comment_faq, text: 'Some question', user_id: user.id)
      faq.question.comments = create(:comment, text: 'Some answer', user_id: user.id)
    end
  end
end
