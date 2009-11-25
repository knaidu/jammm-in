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
    done = true
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
  
end