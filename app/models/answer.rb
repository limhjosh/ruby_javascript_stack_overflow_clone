class Answer < ApplicationRecord
  # Remember to create a migration!
  belongs_to :answerer, class_name: :User
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :votes, as: :votable

end
