class SiteCounter < ActiveRecord::Base
  validates_uniqueness_of :url
  set_table_name "site_counter"
  
  def self.visited(url)
    site = self.find_by_url(url) || self.create(:url => url, :counter => 0)
    site.counter += 1
    site.save
  end
  
end