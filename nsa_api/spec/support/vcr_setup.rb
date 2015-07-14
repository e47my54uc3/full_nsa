VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :faraday
  c.before_http_request do |request|
    VCR.insert_cassette('global', :record => :new_episodes)
  end
  c.after_http_request do |request|
    VCR.eject_cassette
  end
end