module S3

  FILES_BUCKET = "jammm.in"

  def S3.store(obj)
    AWS::S3::S3Object.store_file(obj.file_handle, obj.file)
  end
  
  def S3.store_file(file_handle, file)
    AWS::S3::S3Object.store(file_handle, file, 'jammm.in', :access => :public_read)
  end
  
  def S3.list
    AWS::S3::Service.buckets[0].objects
  end
  
  def S3.exists?(key, bucket=S3::FILES_BUCKET)
    AWS::S3::S3Object.exists?(key, bucket)
  end
  
  def S3.url_for_key(key)
    "http://s3.amazonaws.com/jammm.in/" + key.to_s
  end
  
  def S3.delete(key, bucket=S3::FILES_BUCKET)
    AWS::S3::S3Object.delete(key, bucket)
  end
  
end
