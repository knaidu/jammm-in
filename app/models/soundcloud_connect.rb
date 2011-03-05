require 'net/http'

module SoundCloudConnect
  
  REDIRECT_URL = "http://jammm.in/connect/soundcloud/request_token"
  
  def self.connect_url
    redirect_uri = 
    "https://soundcloud.com/connect?client_id=#{CONFIG['soundcloud_client_id']}&response_type=code&redirect_uri=#{REDIRECT_URL}"
  end
  
  def self.fetch_or_create(user)
    self.find_by_user_id(user.id) or self.create({:user_id => user.id})
  end
  
  def save_access_token(code)
    data = request_token(code)
    self.access_token = data["access_token"]
    self.request_token = data["request_token"]
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
  
end