module HttpRequests
  private

  def open_connection
    @conn = Faraday.new(:url => 'https://gov.blockscore.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def asynch_get_all
    open_connection

    @conn.get do |req|
      req.url '/api/people'
      req.options.timeout = 1
      req.options.open_timeout = 1
    end
  end

  def asynch_get_specific(first_name, last_name)
    JSON.parse(asynch_get_all.body)
    .select do |person|
          person["last_name"] == last_name && person["first_name"] == first_name
    end
  end
end