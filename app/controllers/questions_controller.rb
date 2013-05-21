class QuestionsController < ApplicationController
  before_filter :set_user

  def index
    if params[:group]
      quiz = {}
      questions = Question.where(:group => params[:group])
      answers = Answer.where(:group => params[:group])
      answers.shuffle!
      answers = answers.group_by {|a| a[:question_group]}
      user_answers = UserAnswer.where(:group => params[:group])
      quizzes = Quiz.all
      quizzes.each do |qz|
        quiz[qz.id] = {}
        quiz[qz.id][:questions] = questions
        quiz[qz.id][:answers] = answers
        quiz[qz.id][:user_answers] = user_answers
        quiz[qz.id][:id] = qz.id
      end
      respond_to do |format|
        format.json do
          render :json => {"quizzes" => quiz}, :status => :ok
        end
      end
    else
      respond_to do |format|
        format.json do
          render :json => {"failure "=> "quiz does not exist"}, :status => :bad_request
        end
      end
    end
  end
end
