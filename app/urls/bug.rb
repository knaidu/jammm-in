get '/bug/all' do
  @layout_info = {"middle_panel" => 'bug/all', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end

get '/bug/new' do
  @layout_info = {"middle_panel" => 'bug/new', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end

post '/bug/create' do
  monitor {
    Bug.add(param?(:subject), param?(:description), session_user?)
    "Successfully added bug"
  }
end

get '/bug/:bug_id' do
  @bug = Bug.find(param?(:bug_id))
  @layout_info = {"middle_panel" => 'bug/bug_detailed', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end

post '/bug/:bug_id/add_message' do
  monitor {
    bug = Bug.find(param?(:bug_id))
    bug.add_message(param?(:message))
    "Message added successfully"
  }
end

get '/bug/:bug_id/mark_status' do
  monitor {
    bug = Bug.find(param?(:bug_id))
    bug.mark_status(param?(:bug_status))
    "Status marked successfully"
  }
end

get '/bug/view/:bug_status' do
  @Bugs = Bug.find_all_by_status(param(:bug_status))
  @layout_info = {"middle_panel" => 'bug/view', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end