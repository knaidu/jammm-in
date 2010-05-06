get '/songs' do
  @layout_info = {"middle_panel" => 'homepage/songs', 'left_panel' => 'homepage/left', "right_panel" => "homepage/right"}
  erb(:"body/structure")
end

get '/jams' do
  @layout_info = {"middle_panel" => 'homepage/jams', 'left_panel' => 'homepage/left', "right_panel" => "homepage/right"}
  erb(:"body/structure")
end


get '/artists' do
  @layout_info = {"middle_panel" => 'homepage/artists', 'left_panel' => 'homepage/left', "right_panel" => "homepage/right"}
  erb(:"body/structure")
end

get '/send_invite' do
  monitor {
    email = param?(:email)
    Invite.add(email)
    "Invite has been sent to the email address you mentioned."
  }
end

get '/request_invite' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "homepage/request_invite", "right_panel" => "homepage/right"}
  erb(:'body/structure')
end

post '/request_invite/process' do
  monitor {
    process_invite_request(param?(:name), param?(:email), param?(:is_a), param?(:description))
    "Your request has been registered. You will be hearing from us within the next couple of days. Thank you."
  }
end

get '/terms_and_conditions' do
  erb(:"/help/tandc")
end