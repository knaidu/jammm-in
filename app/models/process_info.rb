class ProcessInfo < ActiveRecord::Base
  set_table_name "process_info"
  validates_uniqueness_of :process_id
  
  def self.add(process_id)
    self.create({:process_id => process_id})
  end
  
  def clear
    self.append({:done => false, :failed => false, :message => ""})
  end
  
  def set_done(message="")
    self.done = true
    self.message = message
    self.save
  end
  
  def set_failed(message="")
    self.failed = true
    self.done = true
    self.message = message
    self.save
  end
  
  def set_message(message="")
    self.message = message
    self.save
  end
  
  def self.format_status(process_id)
    self.find_by_process_id(process_id).format
  rescue
    {}
  end
  
  def format
    attributes.clone.delete_keys("id")
  end
  
  def self.available_process_id
    row = self.find(:all, {:order => "process_id desc", :limit => 1})[0]
    raise if not row
    row.process_id + 1
  rescue
    1
  end
  
end