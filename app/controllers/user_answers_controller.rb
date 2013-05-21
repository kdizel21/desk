class UserAnswersController < ApplicationController
  before_filter :set_user

  def update
    if params[:questions]
      quiz = nil
      begin
        params[:questions].each do |key, question|
          quiz = quiz | question['group']
          @userAnswer = UserAnswer.where(:user_id => session['user'], :group => question['group'], :question_id => question['question']).first
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
        render :json => {:results => check_answers(quiz)}, :status => :ok
      rescue Exception => e
        logger.error e
        render :json => {:error => e}, :status => 500
      end
    end
  end

  def check_answers(quiz)
    return UserAnswer.joins( "INNER JOIN answers ON answers.id = user_answers.answer_id WHERE answers.correct = 't'")
  end
end
