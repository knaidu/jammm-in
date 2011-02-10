ROOT = ENV["WEBSERVER_ROOT"]

load "#{ROOT}/scripts/load_needed.rb"

genres_list = IO.read("#{ROOT}/config/genres.list").split("\n")

categories = ["school"]

categories.each {|c| GroupCategories.create(:name => c)}

cat = GroupCategories.first

Group.create({
  :name => "jammm.in school",
  :handle => "jschool",
  :category_id => cat.id,
})

group = Group.first

group.add_user(User.find(1))
group.add_admin(User.find(1))