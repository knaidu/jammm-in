class SectionHeader
  
  attr_accessor :text, :options
  
  def initialize(text, options={})
    @text = text
    @options = options
  end
  
  def img
    self.options[:img]
  end
    
end