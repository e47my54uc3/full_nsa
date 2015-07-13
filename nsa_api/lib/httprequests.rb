module HttpRequests
  private

  def open_connection(url)
    @conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             
      faraday.response :logger                  
      faraday.adapter  Faraday.default_adapter  
    end
  end

  def timed_get_all
    open_connection('https://gov.blockscore.com')

    @conn.get do |req|
      req.url '/api/people'
      req.options.timeout = 1
      req.options.open_timeout = 1
    end
  end

  def timed_get_user(first_name, last_name)
    JSON.parse(timed_get_all.body).select do |person|
        person["last_name"] == last_name && person["first_name"] == first_name
    end
  end
end