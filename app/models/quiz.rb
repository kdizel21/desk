class Quiz < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :questions
end
