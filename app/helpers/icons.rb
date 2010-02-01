# ICONS 

ICONS = {
  :song => "/images/icons/staff.png",
  :jam => "/images/icons/8thnote.png",
  :notifications => "/images/icons/notification.png",
  :following => "/images/icons/follow2.png",
  :followers => "/images/icons/followers1.png",
  :profile => "/images/icons/profile.png",
  :profile1 => "/images/icons/profile1.png",
  :manage => "/images/icons/manage1.png",
  :jammmin => "/images/icons/miniicon.png",
  :add => "/images/icons/add.png",
  :like => "/images/icons/like.png",
  :unlike => "/images/icons/unlike.png",
  :play => "/images/icons/play.png",
  :play2 => "/images/icons/play1.png",
  :comments => "/images/icons/comments.png",
  :user => "/images/icons/user.png",
  :collaborators => "/images/icons/collaborate.png",
  :update => "/images/icons/update.png",
  :message => "/images/icons/mail2.png",
  :home => "/images/icons/home.png",
  :help => "/images/icons/help1.png",
  :jam_page => "/images/icons/jampage.png",
  :song_page => "/images/icons/songpage1.png",
  :back => "/images/icons/back1.png",
  :refresh => "/images/icons/refresh.png",
  :unfollow => "/images/icons/unfollow1.png",
  :login => "/images/icons/login1.png",
  :logout => "/images/icons/logout1.png"
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

def header_icon(icon)
  "<img src='#{icon}' height='30px'>"  
end

def icon(id, type=:small)
  str = "#{type}_icon('#{ICONS[id]}')"
  eval(str)
end



def add_icon_with_pad(icon=false)
  "<span class='left-float pad-right-10'>#{add_icon(icon)}</span>"
end
