FactoryBot.define do
  factory :secret_question do
    id { 1 }
    question { "あなたの母校" }
  end
  factory :secret_question2, class: SecretQuestion do
    id { 2 }
    question { "学生時代に好きだった人の名前" }
  end
  # factory :three_question, class: SecretQuestion do
  #   id { 3 }
  #   question { "学生時代の思い出の場所" }
  # end
  # factory :four_question, class: SecretQuestion do
  #   id { 4 }
  #   question { "小学校時代に流行っていた遊び" }
  # end
end
