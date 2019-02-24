module RT::REST
  class Session
    attr_accessor :client

    def initialize
      cookies_dir = "#{Rails.root}/lib/request_tracker/rest_api/cookies"
      unless File.directory? cookies_dir
        Dir.mkdir cookies_dir
      end

      @client = RT_Client.new(server:  ENV.fetch('RT_URL'),
                              user:    ENV.fetch('RT_REST_USER'),
                              pass:    ENV.fetch('RT_REST_PASSWORD'),
                              cookies: cookies_dir)
      raise "RT_Session could not establish valid session" if @client.show(1).empty?
    end
  end
end