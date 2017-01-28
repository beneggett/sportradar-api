module Sportradar
  module Api
    class Request

      include HTTParty

      # attr_reader :url, :headers, :timeout, :api_key

      def get(path, options={})
        url, headers, options, timeout = base_setup(path, options)
        begin
          # puts url + "?api_key=#{api_key[:api_key]}" # uncomment for debugging
          response = self.class.get(url, headers: headers, query: options, timeout: timeout)
          rescue Net::ReadTimeout, Net::OpenTimeout
            raise Sportradar::Api::Error::Timeout
          rescue EOFError
            raise Sportradar::Api::Error::NoData
        end
        return Sportradar::Api::Error.new(response.code, response.message, response) unless response.success?
        response
      end

      def get_request_info(url)
        base_setup(request_url(url))
      end

      private

      def base_setup(path, options={})
        @url = set_base(path)
        @url += format unless options[:format] == 'none'
        @headers = set_headers unless options[:format] == 'none'
        @timeout = options.delete(:api_timeout) || Sportradar::Api.config.api_timeout
        [@url, @headers, options.merge(api_key), @timeout]
      end

      def set_base(path)
        protocol = !!Sportradar::Api.config.use_ssl ? "https://" : "http://"
        url = "#{protocol}api.sportradar.us"
        url += path
      end
      

      def date_path(date)
        "#{date.year}/#{date.month}/#{date.day}"
      end

      def week_path(year, season, week)
        "#{ year }/#{ season }/#{ week }"
      end


      def format
        ".#{content_format}" if Sportradar::Api.config.format
      end

      def set_headers
        {'Content-Type' => "application/#{content_format}", 'Accept' => "application/#{content_format}"}
      end

      def content_format
        Sportradar::Api.config.format
      end

      def api_key
        raise Sportradar::Api::Error::NoApiKey
      end
    end
  end
end

__END__

require 'typhoeus'
require 'nokogiri'
sr = Sportradar::Api::Basketball::Nba.new
# sd = sr.daily_schedule(Date.new(2017, 1, 23));
sd = sr.daily_schedule(Date.new(2017, 1, 21));
# typhs = sd.games.map(&:typh_pbp)
games = sd.games
hydra = Typhoeus::Hydra.new
requests = games.map do |game|
  data = game.queue_pbp
  request = Typhoeus::Request.new(data[:url], headers: data[:headers], params: data[:params], method: :get)
  request.on_complete do |response|
    xml = Nokogiri::XML(response.body)
    resp = Hash.from_xml(xml.to_s)
    game.send(data[:callback], resp)
  end
  hydra.queue request
  request
end
t = Time.now; rr = hydra.run; Time.now - t
t = Time.now; games.each(&:get_pbp); Time.now - t
# typhs.each {|r| hydra.queue r };
t = Time.now; hydra.run; Time.now - t


sr = Sportradar::Api::Basketball::Nba.new;
sd = sr.daily_schedule(Date.new(2017, 1, 21));
games = sd.games;
t = Time.now; games.each(&:get_pbp); Time.now - t
