class Question < ActiveRecord::Base
  scope :top,->(){ order('votes_count DESC') }
  validates :title, :body, presence: true
  belongs_to :user
  belongs_to :category
  has_many :answers
  has_many :comments, as: :commentable
  has_many :votes, as: :voteable

  def self.search_question(searched_words)
    matches = []
    if searched_words != nil
    searched_words.each do |search|
      Question.all.select { |q| matches << q if q.title.downcase.include?(search.downcase)}
    end
    else
    end
    matches.uniq
  end

  def vote_count
    self.votes.reduce(0) {|count, vote| count += vote.value}
  end


end
