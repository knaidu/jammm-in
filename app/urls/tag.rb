get '/tag/add' do
  monitor {
    Tag.add(param?(:name), param?(:for_type), param?(:for_type_id))
    "Successfully added tag"
  }
end


get '/tag/remove' do
  monitor {
    contains_tag_id = param?(:contains_tag_id)
    ContainsTag.find(contains_tag_id).destroy
  }
end
