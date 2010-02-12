class Image
  
  attr_accessor :info, :path
  
  def initialize(path)
    @path = path
    __run_info(path)
  end
  
  def __run_info(path)
    temp = run("identify -verbose #{path}").split("\n")
    temp.shift
    @info = YAML.load(temp.join("\n"))
  rescue 
    {}
  end
  
  def width
    run("identify -format %w #{@path}").sub("\n" ,'').to_i
  end
  
  def height
    run("identify -format %h #{@path}").sub("\n" ,'').to_i    
  end
  
  def scale_and_resize(width, height)
    
  end
  
  def scale_to_px(width, height)
    
  end
  
  def resize_and_crop(new_width, new_height)
    w = h = nil
    if (self.width < self.height)
      w = new_width 
      h = (self.height * w) / self.width
    else
      h = new_height
      w = (self.width * h) / self.height
    end
    resize(w,h) # resizes in scale
    crop(new_width, new_height)
  end
  
  def resize(new_width, new_height)
    run("convert #{path} -resize #{new_width}x#{new_height} #{path}")
  end
  
  def crop(new_width, new_height)
    run ("convert #{path} -crop #{new_width}x#{new_height}+0+0 #{path}")
  end
  
end