get '/genre/add' do
  monitor {
    genre = Genre.find(param?(:genre_id))
    ContainsGenre.add(genre, param?(:for_type), param?(:for_type_id))
  }
end


get '/genre/remove' do
  monitor {
    contains_genre_id = param?(:contains_genre_id)
    ContainsGenre.find(contains_genre_id).destroy
  }
end