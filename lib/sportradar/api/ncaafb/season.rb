module Sportradar
  module Api
    class Ncaafb
      class Season < Data
        attr_accessor :response, :id, :year, :type, :name, :injuries, :team, :conferences, :divisions, :teams

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          # @season   = response['season'] # removing this to reduce ambiguity
          @year     = response['season']
          @type     = response['type']

          # weeks
          # set_conferences
          # set_divisions
          # set_teams
        end

        # private

        def weeks(number = nil)
          @weeks_hash ||= parse_into_array_with_options(selector: response["week"], klass: Sportradar::Api::Ncaafb::Week, api: @api, season: self).map { |w| [w.sequence.to_i, w] }.to_h
          number ? @weeks_hash[number.to_i] : @weeks_hash.values
        end

        # set_(conferences|divisions|teams) are all identical to the same methods in Hierarchy
        # There is likely more overlap between Sportradar's NFL standings and NFL hierarchy APIs
        # Eventually, these should be shared between classes
        # def set_conferences
        #   @conferences ||= parse_into_array(selector: response["week"], klass: Sportradar::Api::Ncaafb::Week)
        #   if response["conference"]
        #     if response["conference"].is_a?(Array)
        #       @conferences = response["conference"].map {|conference| Sportradar::Api::Nfl::Conference.new conference }
        #     elsif response["conference"].is_a?(Hash)
        #       @conferences = [ Sportradar::Api::Nfl::Conference.new(response["conference"]) ]
        #     end
        #   end
        # end

        # def set_divisions
        #   if conferences&.all? { |conference| conference.divisions }
        #     @divisions = conferences.flat_map(&:divisions)
        #   elsif response["division"]
        #     if response["division"].is_a?(Array)
        #       @divisions = response["division"].map {|division| Sportradar::Api::Nfl::Division.new division }
        #     elsif response["division"].is_a?(Hash)
        #       @divisions = [ Sportradar::Api::Nfl::Division.new(response["division"]) ]
        #     end
        #   end
        # end

        # def set_teams
        #   @teams = @divisions.flat_map(&:teams) if divisions&.all? {|division| division.teams }
        # end

      end
    end
  end
end


__END__

sr = Sportradar::Api::Ncaafb.new;
ss = sr.schedule;
week_count = ss.weeks.count;
w1 = ss.weeks.first;
w1 = ss.weeks(1);
teams = ss.weeks(1).games.flat_map(&:teams);
t = teams.first;
