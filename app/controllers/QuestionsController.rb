# index
get '/questions' do

end

# new
get '/questions/new' do
  if session[:id]
    @categories = Category.all
    erb :'questions/new'
  else
    redirect 'users/new'
  end
end

post '/questions/:question_id/answer/:id/vote' do
if session[:id]
    @question = Question.find_by(id: params[:question_id])
    @category = @question.category
    @answer = Answer.find_by(id: params[:id], question_id: params[:question_id])
    @vote = Vote.new(voteable_type: "Answer", voteable_id: params[:id], user_id: session[:id], value: 1)
    if @vote.save
     if request.xhr?
       content_type :json
       {id: @answer.id, count: @answer.votes.count,  total: @answer.vote_count}.to_json
     else
       redirect :"questions/#{@question.id}"
     end
  end
 end
end

post '/questions/:question_id/answer/:id/downvote' do
if session[:id]
    @question = Question.find_by(id: params[:question_id])
    @category = @question.category
    @answer = Answer.find_by(id: params[:id], question_id: params[:question_id])
    @vote = Vote.new(voteable_type: "Answer", voteable_id: params[:id], user_id: session[:id], value: -1)
    if @vote.save
     if request.xhr?
       content_type :json
       {id: @answer.id, total: @answer.votes.count,  count: @answer.vote_count}.to_json
     else
       redirect :"questions/#{@question.id}"
    end
   end
  end
end

post '/questions/:id/vote' do
 # Tried to implement logic to only allow a user to vote once - not working yet
 # @repeater = Vote.find_by(user_id: session[:id]).voteable_id
 # if @repeater.include?(params[:id])
 if session[:id]
   @question = Question.find_by(id: params[:id])
   @category = @question.category
   @vote = Vote.new(voteable_type: "Question", voteable_id: params[:id], user_id: session[:id], value: 1)
   if @vote.save
    if request.xhr?
      @voted_question = Vote.find_by(voteable_type: "Question", voteable_id: @question.id, user_id: session[:id])
      content_type :json
      {id: @question.id, count: @question.votes.count, total: @question.vote_count}.to_json
    else
      erb :'categories/show'
    end
   end
  end
end

post '/questions/:id/downvote' do
 # Tried to implement logic to only allow a user to vote once - not working yet
 # @repeater = Vote.find_by(user_id: session[:id]).voteable_id
 # if @repeater.include?(params[:id])
 if session[:id]
    @question = Question.find_by(id: params[:id])
    @vote = Vote.new(voteable_type: "Question", voteable_id: params[:id], user_id: session[:id], value: -1)
    if @vote.save
     if request.xhr?
      @voted_question = Vote.find_by(voteable_type: "Question", voteable_id: @question.id, user_id: session[:id])
       content_type :json
       {id: @question.id, count: @question.votes.count, total: @question.vote_count}.to_json
     else
       erb :'categories/show'
     end
    end
  end
end

# create
post '/questions' do
  @question = Question.create(
    title: params[:question][:title],
    body: params[:question][:body],
    category_id: params[:category],
    user_id: session[:id])
  redirect :"questions/#{@question.id}"
end

# show
get '/questions/:id' do
  # puts params
  @question = Question.find(params[:id])
  @answers = @question.answers.top
  erb :'questions/show'
end

# edit
get '/questions/:id/edit' do
  @categories = Category.all
  @question = Question.find(params[:id])
  erb :'questions/update_question'
end

# update
put '/questions/:id' do
  @categories = Category.all
  @question = Question.find(params[:id])
  @question.update_attributes(params[:question])
  @question.save
  redirect "/questions/#{@question.id}"
end

delete '/questions/:id' do
   @question = Question.find_by(id: params[:id])
   @user = @question.user.id
   @question.destroy
   redirect to "/users/#{@user}"
end

# new answer
get '/questions/:id/answers/new' do
  if session[:id]
    @question = Question.find(params[:id])
    if request.xhr?
      erb :'answers/new', layout: false
    else
      erb :'answers/new'
    end
  else
    redirect '/'
  end
end

# create answer
post '/questions/:id/answers' do
  question = Question.find(params[:id])
  @answer = Answer.create(
    body: params[:answer][:body],
    question_id: question.id,
    user_id: session[:id])
  redirect :"questions/#{params[:id]}"
end

get '/questions/:id/comments/new' do
  if session[:id]
    @question = Question.find(params[:id])
    if request.xhr?
      erb :'questions/new_comment', layout: false
    else
      erb :'questions/new_comment'
    end
  else
    redirect '/'
  end
end

post '/questions/:id/comments' do
  question = Question.find(params[:id])
  @comment = Comment.create(
    body: params[:comment][:body],
    commentable_type: 'Question',
    commentable_id: params[:id],
    user_id: session[:id])

    redirect :"questions/#{params[:id]}"
end

get '/answers/:id/comments/new' do
  if session[:id]
    @answer = Answer.find(params[:id])
    if request.xhr?
      erb :'answers/new_comment', layout: false
    else
      erb :'answers/new_comment'
    end
  else
    redirect '/'
  end
end

post '/answers/:id/comments' do
  answer = Answer.find(params[:id])
  @comment = Comment.create(
    body: params[:comment][:body],
    commentable_type: 'Answer',
    commentable_id: params[:id],
    user_id: session[:id])
  redirect :"questions/#{answer.question.id}"
end


get '/questions/:question_id/answers/:id/edit' do
  @question = Question.find(params[:question_id])
  @answer = Answer.find(params[:id])
  erb :'answers/update_answer'
end

put '/questions/:question_id/answers/:id' do
  @question = Question.find(params[:question_id])
  @answer = Answer.find(params[:id])
  @answer.update_attributes(params[:answer])
  @answer.save
  redirect "/questions/#{@question.id}"
end

