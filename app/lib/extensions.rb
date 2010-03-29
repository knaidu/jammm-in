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
    self.gsub("\n", "<br>")
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
