class FaradayTimeout < Faraday::Middleware
  def call(env)
    begin
      @app.call(env)
    rescue Faraday::Error::ConnectionFailed => e
      url = env[:url].to_s.gsub(env[:url].path, '')
      @delayed = {status: 408, error: "The server at #{url} is either unavailable or is not currently accepting requests. Please try again in a few minutes."}.to_json 
    end
  end
end