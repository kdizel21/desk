class QuizzesController < ApplicationController
  before_filter :set_user

  def index
    quizzes = Quiz.all
    render :json => {:quizzes => quizzes}
  end
end
