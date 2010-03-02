class SiteCounter < ActiveRecord::Base
  validates_uniqueness_of :url
  set_table_name "site_counter"
  
  def self.visited(url)
    url = self.format_url(url)
    return if not url
    site = self.find_by_url(url) || self.create(:url => url, :counter => 0)
    site.counter += 1
    site.save
  end
  
  def self.format_url(url)
    url = url.sub("/undefined", "/")
    url += "/" if (url.grep /\/$/).empty?
    url
  end
  
  def self.total_visited
    sql("select sum(counter) from site_counter")[0]["sum"].to_i
  end
  
end
