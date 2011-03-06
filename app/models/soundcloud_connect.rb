require 'net/http'

class SoundCloudConnect < ActiveRecord::Base
  set_table_name "soundcloud_connect"
  has_one :user
    
  REDIRECT_URL = "http://jammm.in/connect/soundcloud/request_token"
  
  def self.connect_url
    "https://soundcloud.com/connect?client_id=#{CONFIG['soundcloud_client_id']}&response_type=code&redirect_uri=#{REDIRECT_URL}"
  end
  
  def self.fetch_or_create(user)
    self.find_by_user_id(user.id) or self.create({:user_id => user.id})
  end
  
  def save_tokens(code)
    data = request_token(code)
    self.access_token = data["access_token"]
    self.refresh_token = data["refresh_token"]
    self.expires_at = Time.now + data["expires_in"]
    self.save
  end
  
  def request_token(code)
    http = Net::HTTP.new('api.soundcloud.com', 443)
    http.use_ssl = true
    path = '/oauth2/token'
    
    q = {
      "client_id" => CONFIG["soundcloud_client_id"],
      "client_secret" => CONFIG["soundcloud_client_secret"],
      "grant_type" => "authorization_code",
      "redirect_uri" => REDIRECT_URL,
      "code" => code
    }
    
    data_string = q.map{|k,v| "#{k}=#{v}"}.join("&")
    puts data_string
    resp, data = http.post(path, data_string)
    data.eval_json
  end
  
  def public_tracks
    tracks = get_http_response("https://api.soundcloud.com/me/tracks.json", {"oauth_token" => self.access_token}).body.eval_json
#    tracks.select{|t| t["downloadable"]}
  end
  
  def fetch_tracks(ids=[])
    public_tracks.select{|t| ids.include?(t["id"])}
  end
  
  def download_track(track, output_file)
    track_url = track["stream_url"] + "?oauth_token=#{access_token}&secret_token=#{track['secret_token']}"
    cmd = "wget --no-check-certificate \"#{track_url}\" -O #{output_file}"
    run(cmd)
  end
  
end