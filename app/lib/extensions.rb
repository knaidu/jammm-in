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