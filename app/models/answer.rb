class Answer < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :question
  attr_accessible :answer, :correct, :group, :question_group
end
