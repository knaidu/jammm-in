# ICONS 

def icon(url, index, width, container=false)
  str = "<img src='#{url}' style='margin-left: -#{index * width}px'>"
  return str unless container
  "<div style='width: #{width}px; overflow: hidden'>#{str}</div>"
end