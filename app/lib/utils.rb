
# ONE TIME OP: Loads all layout info into global variable $layout_info
$layout_info = YAML.load_file("#{ENV["WEBSERVER_ROOT"]}/config/layout.yml")
FILES_DIR = ENV["FILES_DIR"]
APP_ROOT = ENV["WEBSERVER_ROOT"]

def run(cmd)
  puts "RUNNING: #{cmd}"
  `#{cmd}`
end

def get_passed_song
  Song.find(params[:song_id])
end

def get_passed_jam
  Jam.find(params[:jam_id])
end

def new_file_handle_name
  Time.now.to_f.to_s.gsub('.', '-') + ".mp3"
end

def file_handle_path(obj)
  FILES_DIR + "/" + obj.file_handle if obj.file_handle
end

def utils_make_copy_of_file_handle(old_handle_name, new_handle_name=nil)
  new_handle_name ||= new_file_handle_name
  puts "old: #{old_handle_name}, new #{new_handle_name}"
  new_handle_name if File.copy(FILES_DIR + "/" + old_handle_name, FILES_DIR + "/" + new_handle_name)
end

def session_user
  User.with_username(session[:username]) or nil
end

def set_session_user(user)
  session[:username] = user.username
end

def unset_session_user
  session[:username] = nil
  @session_user = nil
end

def sql(str)
  ActiveRecord::Migration.execute str
end

def get_params(*parameters)
  parameters.map do |param| params["#{param}"] end
end

def layout_info(section, subsection=false)
  section_str = section.to_s
  section = $layout_info[section]
  subsection = section[subsection] || section
  h = {'section' => section_str}
  ['left_panel', 'right_panel', 'middle_panel'].each do |i|
    h[i] = ("#{section_str}/" + (subsection[i] || section[i]) rescue "")
  end
  h
end

def subsections(section)
  $layout_info[section].map{|k, v| v.class.to_s.downcase == 'hash' ? k : nil}.compact
end

def md5(str)
  Digest::MD5.hexdigest(str)
end

def allow_login?(username, password)
  password = md5(password)
  true if User.find_by_username_and_password(username, password)
end
