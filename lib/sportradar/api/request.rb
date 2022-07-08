module Sportradar
  module Api
    class Request
      attr_reader :qps_allotted, :qps_current, :quota_allotted, :quota_current

      include HTTParty

      # attr_reader :url, :headers, :timeout, :api_key

      def sim!
        @access_level = 'sim'
        self
      end

      def get_data(url, extra_params = {})
        data = get(request_url(url), extra_params)
        if data.is_a?(::Sportradar::Api::Error)
          puts request_url(url)
          puts
          puts data.inspect
          raise data
        end
        parse_usage(data.headers)
        data
      end

      def usage
        {
          qps_allotted:   @qps_allotted,
          qps_current:    @qps_current,
          quota_allotted: @quota_allotted,
          quota_current:  @quota_current,
        }
      end

      def parse_usage(headers)
        @qps_allotted   = (headers['x-plan-qps-allotted']   || headers['x-packagekey-qps-allotted']).to_i
        @qps_current    = (headers['x-plan-qps-current']    || headers['x-packagekey-qps-current']).to_i
        @quota_allotted = (headers['x-plan-quota-allotted'] || headers['x-packagekey-quota-allotted']).to_i
        @quota_current  = (headers['x-plan-quota-current']  || headers['x-packagekey-quota-current']).to_i
      end

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
        unless response.success?
          puts url + "?api_key=#{api_key[:api_key]}" # uncomment for debugging
          puts
          puts response.inspect
          Sportradar::Api::Error.new(response.code, response.message, response)
        else
          response
        end
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
      
      def default_date
        Date.today
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
