class UserAnswer < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  has_many :answers
end
