class UserAnswersController < ApplicationController
  before_filter :set_user

  def update
    if params[:questions]
      quiz = nil
      params[:questions].each do |question|

        quiz = quiz | question['group'].to_i
        @userAnswer = UserAnswer.where(:user_id => session['user'], :group => question['group'], :question_id => question['question'])
        if @userAnswer
          @userAnswer.answer_id = question['answer']
        else
          @userAnswer = UserAnswer.new
          @userAnswer.group = question['group']
          @userAnswer.question_id = question['question']
          @userAnswer.answer_id = question['answer']
          @userAnswer.user_id = session["user"]
        end
        @userAnswer.save!
      end
      #check_answers(quiz)
    end
  end

  def check_answers(quiz)
    #return Answer.
  end
end
