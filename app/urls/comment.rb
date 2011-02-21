
post '/comments/add' do
  user = User.with_username(session[:username])
  comment = params[:comment]
  for_type_id = params[:for_type_id]
  for_type = params[:for_type]
  comment = Comment.add(user, comment, for_type, for_type_id)
  erb(:"/common/comment", :locals => {:comment => comment, :managers => []})
end


get '/comments/fetch' do
  for_type_id = params[:for_type_id]
  for_type = params[:for_type]
  comments_div_id = params[:comments_div_id]
  comments = Comment.fetch(for_type, for_type_id)
  erb(:'common/comments', :locals => {
      :for_type => for_type, 
      :for_type_id => for_type_id, 
      :comments_div_id => comments_div_id,
      :comments => comments
  })
end

post '/comments/delete' do
  id = params[:id]
  Comment.find(id).remove_comment(session_user) ? "Deleted comment"  : "Error in deleting comment"
end