ROOT = ENV["WEBSERVER_ROOT"]

load "#{ROOT}/scripts/load_needed.rb"

genres_list = IO.read("#{ROOT}/config/genres.list").split("\n")

# Inserts all te Genres
genres_list.each do |genre|
  Genre.create(:name => genre)
end

# Deletes the Genres not listed in the file
Genre.all.each do |genre|
  genre.destroy if not genres_list.include?(genre.name)
end