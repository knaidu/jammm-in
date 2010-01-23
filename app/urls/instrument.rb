get '/instrument/add' do
  monitor {
    instrument = Instrument.find(param?(:instrument_id))
    ContainsInstrument.add(instrument, param?(:for_type), param?(:for_type_id))
  }
end


get '/instrument/remove' do
  monitor {
    contains_instrument_id = param?(:contains_instrument_id)
    ContainsInstrument.find(contains_instrument_id).destroy
  }
end