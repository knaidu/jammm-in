module Extensions

end

class Array
  def split_at(index)
    temp_arr = []
    temp_arr.push(self.slice(0, index+1))
    temp_arr.push(self.slice(index+1, self.size)) if self.size > 2
    temp_arr
  end
  
  def without(x)
    self.reject{|a| a == x}
  end
end

class String
  def eval_json; JSON.parse self; end
  
  def format_html
    self.gsub("\n", "<br>").gsub_href
  end
  
  def gsub_href
    self.gsub(eval(DATA["href_regex"])) {|href|
      "<a href='#{href}' target='_blank' class='default-color'>#{href}</a>"
    }
  end
  
  def px # Used in common.css
    gsub("px", "").to_i
  end
  
end

class File
  def size
    File.size(self.path) rescue nil
  end
end

class Time
  def date
    strftime("%d/%m/%Y")
  end
  
  def reference_string
    now = Time.now
    diff_arr = [now.day, now.month, now.year].zip([day, month, year]).map{|a| a[0] - a[1]}
    if diff_arr[2] > 0 
      self.strftime("%B, %Y")
    elsif diff_arr[1] > 0 
      self.strftime("%B")
    else
      if diff_arr[0] == 0
        "Today"
      elsif diff_arr[0] == 1
        "Yesterday"
      elsif diff_arr[0] == 2
        "2 days ago"
      elsif diff_arr[0] > 0 and diff_arr[0] < 10
        "In the past 10 days" 
      else
        "This Month"
      end
    end
  end
  
end

class Hash
  def keys_to_sym
    hash = {}
    self.each do |key, value| hash[key.to_sym] = value end
    hash
  end
  
  def delete_keys(*keys)
    keys.each do |key| self.delete(key) end
    self
  end
end

class Object
  def sym?
    self.class.to_s.downcase == 'symbol'
  end
  
  def to_bool
    if t = self.to_s
      return false if t.downcase == 'false'
    end
    not not self
  end
end

class Integer
  def px; (self.to_s + "px"); end # Used in common.css
  
  def to_mb
    self.to_f.to_mb
  end
  
  def to_time_str
    (self / 60).to_s + "m " + (self % 60).to_s + 's'
  end
  
end

class Float
  def to_mb
    (self / 1024 / 1024).round_to(2).to_s + " MB"
  end
  
  def round_to(x)  
    (self * 10**x).round.to_f / 10**x  
  end  

  def ceil_to(x)  
    (self * 10**x).ceil.to_f / 10**x  
  end  

  def floor_to(x)  
    (self * 10**x).floor.to_f / 10**x  
  end
end