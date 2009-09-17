module Utils
  
  def layout_info(section, subsection=false)
    section_str = section.to_s
    section = $layout_info[section]
    subsection = section[subsection] rescue section
    h = {}
    ['left_panel', 'right_panel', 'middle_panel'].each do |i|
      h[i] = "#{section_str}/" + (subsection[i] || section[i])
    end
    h
  end
  
end

# ONE TIME OP: Loads all layout info into global variable $layout_info
$layout_info = YAML.load_file('config/layout.yml')