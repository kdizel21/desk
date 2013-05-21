class Question < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :quiz
  has_many :answers

  attr_accessible :question, :group
end
