def fhlp_get_users(feed)
  feed.data.keys_to_sym[:user_ids].map {|user| User.find(user)} rescue nil
end

def fhlp_get_jam(feed)
  Jam.find(feed.data['jam_id'])
end

def fhlp_get_song(feed)
  Song.find(feed.data['song_id'])
end

def global_feeds
  (Feed.find_by_sql [
      "SELECT f.*",
      "FROM feeds f",
      "WHERE",
      "f.scope = 'global' OR f.scope = 'public'",
      "ORDER BY created_at DESC"
    ].join(' ')
  ).uniq
end
