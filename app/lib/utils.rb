module Utils
  
  def get_passed_song
    Song.find(params[:song_id])
  end
  
  def get_passed_jam
    Jam.find(params[:jam_id])
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
  
end

# ONE TIME OP: Loads all layout info into global variable $layout_info
$layout_info = YAML.load_file('config/layout.yml')
FILES_DIR = ENV["FILES_DIR"]