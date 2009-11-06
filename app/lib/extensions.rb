module Extensions

end

class Array
  
end

class String
  def eval_json; JSON.parse self; end
end