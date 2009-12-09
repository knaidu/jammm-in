get '/process_info/:process_id' do
  ProcessInfo.format_status(params[:process_id]).to_json
end