
# ONE TIME OP: Loads all layout info into global variable $layout_info
$layout_info = YAML.load_file("#{ENV["WEBSERVER_ROOT"]}/config/layout.yml")
INVALID_INFO = YAML.load_file("#{ENV["WEBSERVER_ROOT"]}/config/invalid.yml")
DATA = YAML.load_file("#{ENV["WEBSERVER_ROOT"]}/config/data.yml")
BADGES_DATA = YAML.load_file("#{ENV["WEBSERVER_ROOT"]}/config/badges.yml")
FILES_DIR = ENV["FILES_DIR"]
APP_ROOT = ENV["WEBSERVER_ROOT"]

def run(cmd)
  puts "RUNNING: #{cmd}"
  `#{cmd}`
end

def argv_options
  options = {}
  ARGV.each do |arg|
    res = (/--(.+)=(.+)/ =~ arg)
    options[$1.to_sym] = $2 if res and $1 and $2
  end
  options
end


def get_localhost_response(path)
  Net::HTTP.get("localhost", path)
end


def get_passed_song
  Song.find(params[:song_id])
end

def get_passed_jam
  Jam.find(params[:jam_id])
end

def get_passed_user
  User.with_username(params[:username])
end

def get_passed_users_by_id
  params[:user_ids].split(",").map do |id| User.find(id) end
end

def new_file_handle_name(ext=".mp3")
  ext = "" if not ext
  Time.now.to_f.to_s.gsub('.', '-') + ext
end

def file_handle_path(obj)
  FILES_DIR + "/" + obj.file_handle if obj.file_handle
end

def utils_make_copy_of_file_handle(old_handle_name, new_handle_name=nil)
  puts "copy 2"
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

def param?(key)
  params.has_key?(key.to_s) ? params[key] : nil
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

def add_message(user_1, user_2, body)
  raise "Please enter a message in the textfield" if body.blank? or body.nil?
  message_stream = MessageStream.find_stream(user_1, user_2) || MessageStream.start([user_1, user_2])
  message_stream.add_message(user_1, body)
end

def parse_url(url)
  puts url
  path, parameters = url.split('?')
  p = {}
  
  parameters.split("&").each { |param|
    res = (/(.+)=(.+)/ =~ param)
    p[$1.to_sym] = $2 if res and $1 and $2
  } if parameters
  
  {:path => path, :params => p}
end

def get_add_music_info
  music_type, music_id = param?(:add).split("_") if param?(:add)
  [eval(music_type.capitalize), music_id]
end

def download_to_server(url, output_file_path = false)
  output_file_option = "-O #{output_file_path}" if output_file_path
  cmd = "wget #{url} #{(output_file_option if output_file_path)}"
  run(cmd)
end

def get_storage_file_path(file_handle)
  ENV["STORAGE_DIR"] + "/" + file_handle
end

def get_storage_file(file_handle)
  path = get_storage_file_path(file_handle)
  return false if not File.exists?(path)
  File.open(path)
end

def delete_storage_file(file_handle)
  path = ENV["STORAGE_DIR"] + "/" + file_handle
  File.delete(path) if File.exists?(path)
end

# CACHING START

def cache_file(obj)
  return File.new(ENV['CACHE_DIR'] + "/" + obj.file_handle) if cache_file_exists?(obj.file_handle)
end

def cache_file_exists?(filename)
  file_path = ENV["CACHE_DIR"] + "/" + filename
  File.new(file_path) if File.exists?(file_path)
end

def cache(file_handle)
  return true if cache_file_exists?(file_handle)
  download_path = ENV["CACHE_DIR"] + "/" + file_handle
  download_to_server(S3.url_for_key(file_handle), download_path)
  cache_file_exists?(file_handle)
end


def fetch_local_file_path(obj)
  (cache_file_exists?(obj.file_handle) or obj.file or cache(obj.file_handle)).path
end


# CACHING END


def obj_from_data(for_type, for_type_id)
  eval(for_type.capitalize).find(for_type_id)
end

def increment_site_counter(url)
  SiteCounter.visited(url)
end

def increment_music_counter(file_handle)
  objs = Song.find_all_by_file_handle(file_handle) + Jam.find_all_by_file_handle(file_handle)
  objs.each(&:visited)
end
  


# Search

def search_with_key(key)
  users = User.find_by_sql("select * from users where name ~* '#{key}' or username ~* '#{key}'")
  jams = Jam.find_by_sql("select * from jams where name ~* '#{key}'")
  songs = Song.find_by_sql("select * from songs where name ~* '#{key}'")  
  (users + jams + songs).sort_by(&:created_at)
end

# BUGS

def mark_bug_status(bug, bug_status)
  bug.mark_status bug_status
end

def mark_bug_fixed(bug)
  mark_bug_status(bug, "fixed")
end

# CRON JOBS
def cron_log(msg)
  file = File.new("#{ENV["STORAGE_DIR"]}/cron.log", "a")
  template = "[#{Time.now.to_s}] #{msg}"
  file.puts(template)
  file.close
end

def cron_log_new_section(section)
  cron_log("===========================")
  cron_log(section)
  cron_log("===========================")
end

# MUSIC META DATA
def music_meta_data(obj)
  {
    :title => uri_encode(obj.name),
    :image_src => (obj.song_picture_url rescue obj.artists.shuffle.pop.profile_picture_url),
    :file => obj.file_handle,
    :artists => obj.artists.map(&:username).join(','),
    :description => obj.description,
    :page_url => "http://jammm.in/#{obj.class.to_s.downcase}/#{obj.id.to_s}"
  }
end

# REQUEST INVITE 
def process_invite_request(name, email, is_a, description)
  raise "Kindly fill Name and Email field as they are mandatory" if name.nil? or name.blank? or email.nil? or email.blank?
  mail_info = {
    :from => "support@jammm.in",
    :password => "3WiseMen",
    :subject => "Invite Request - #{name}",
    :body => "name: #{name}; email: #{email}; is_a: #{is_a}, desc: #{description}",
    :to => "prakashraman@jammm.in, tarun@jammm.in"
  }
  mail(mail_info)
end

def uri_encode(str)
  CGI::escape(str)
end
