module HttpRequests
  private

  def open_connection(url)
    @conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :json            
      faraday.response :json, :content_type => /\bjson$/                  
      faraday.adapter  Faraday.default_adapter  
    end
  end

  def timed_get_all
    open_connection('https://gov.blockscore.com')
    begin
      @conn.get do |req|
        req.url '/api/people'
        req.options.timeout = 2
        req.options.open_timeout = 2
      end
    rescue Faraday::Error::ConnectionFailed, Faraday::TimeoutError => e
      @delayed = {error: "Uh oh! We're experiencing heavy traffic right now.. please try again in a moment",
        status: 408
      }
    end

  end

  def timed_get_user(first_name, last_name)
    timed = timed_get_all
    
    return @delayed if @delayed
  
    timed.body.select do |person|
        person["last_name"] == last_name && person["first_name"] == first_name
    end
  end
end