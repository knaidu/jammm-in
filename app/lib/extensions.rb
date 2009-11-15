module Extensions

end

class Array

end

class String
  def eval_json; JSON.parse self; end
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