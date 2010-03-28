get '/bug/all' do
  @layout_info = {"middle_panel" => 'bug/all', 'left_panel' => 'homepage/left', 'right_panel' => "bug/right"}
  erb(:"body/structure")
end

get '/bug/new' do
  @layout_info = {"middle_panel" => 'bug/new', 'left_panel' => 'homepage/left', 'right_panel' => "bug/right"}
  erb(:"body/structure")
end

post '/bug/create' do
  monitor {
    Bug.add(param?(:subject), param?(:description), session_user?)
    "Successfully added bug"
  }
end

get '/bug/view/:bug_status' do
  @layout_info = {"middle_panel" => 'bug/view_by_status', 'left_panel' => 'homepage/left', 'right_panel' => "bug/right"}
  @bugs = Bug.find_all_by_status(param?(:bug_status), {:order => "id DESC"})
  erb(:"body/structure")
end

get '/bug/:bug_id' do
  @bug = Bug.find(param?(:bug_id))
  @layout_info = {"middle_panel" => 'bug/bug_detailed', 'left_panel' => 'homepage/left', 'right_panel' => "bug/right"}
  erb(:"body/structure")
end

post '/bug/:bug_id/add_message' do
  monitor {
    bug = Bug.find(param?(:bug_id))
    bug.add_message(param?(:message), session_user?)
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
