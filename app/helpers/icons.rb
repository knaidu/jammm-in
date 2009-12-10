# ICONS 

ICONS = {
  :song => "/images/icons/staff.png",
  :jam => "/images/icons/8thnote.png"
}

def add_icon(icon=false)
  "<img src='/images/common/icon.png'>"
end

def medium_icon(icon='/images/common/icon.png')
  "<img src='#{icon}' height=32 width=32>"
end

def small_icon(icon='/images/common/icon.png')
  "<img src='#{icon}' height=16 width=16>"
end

def icon(id, type=:small)
  if type == :small
    small_icon(ICONS[id])
  elsif type == :medium
    medium_icon(ICONS[id])    
  end
end



def add_icon_with_pad(icon=false)
  "<span class='left-float pad-right-10'>#{add_icon(icon)}</span>"
end
