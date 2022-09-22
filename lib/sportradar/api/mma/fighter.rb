module Sportradar
  module Api
    module Mma
      class Fighter < Data
        attr_accessor :response, :id, :height, :weight, :reach, :stance, :name, :first_name, :nick_name, :last_name, :record, :born, :out_of, :qualifier, :abbreviation

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @roster   = opts[:roster]
          @fights_hash = {}

          @id       = data['id']

          update(data)
        end

        def fights
          @fights_hash.values
        end
        def add_fight(fight)
          @fights_hash[fight.id] = fight if fight
        end

        def display_name
          if first_name && last_name
            "#{first_name} #{last_name}"
          else
            @name || @short_name
          end
        end

        def update(data, **opts)
          @name         = data['name']          if data['name']
          @abbreviation = data['abbreviation']  if data['abbreviation']
          @short_name   = data['short_name']    if data['short_name']

          @qualifier  = data['qualifier']  if data['qualifier']     # "72",
          @abbreviation  = data['abbreviation']  if data['abbreviation']     # "72",
          @height     = data['height']     if data['height']     # "72",
          @weight     = data['weight']     if data['weight']     # "170",
          @reach      = data['reach']      if data['reach']      # "",
          @stance     = data['stance']     if data['stance']     # "",
          @first_name = data['first_name'] if data['first_name'] # "Sai",
          @nick_name  = data['nick_name']  if data['nick_name']  # "The Boss",
          @last_name  = data['last_name']  if data['last_name']  # "Wang",
          @name       = data['name']       if data['name']       # "Wang, Sai",
          @record     = data['record']     if data['record']     # {"wins"=>"6", "losses"=>"4", "draws"=>"1", "no_contests"=>"0"},
          @born       = data['born']       if data['born']       # {"date"=>"1988-01-16", "country_code"=>"UNK", "country"=>"Unknown", "state"=>"", "city"=>""},
          @out_of     = data['out_of']     if data['out_of']     # {"country_code"=>"UNK", "country"=>"Unknown", "state"=>"", "city"=>""}}

          self
        end

        def path_base
          "participants/#{ id }"
        end
        def path_profile
          "#{ path_base }/profile"
        end

        def get_profile
          data = api.get_data(path_profile)['profile'].dig('fighters', 'fighter')
          update(data)
          self
        end
        def api
          @api ||= Sportradar::Api::Mma.new
        end



        KEYS_SCHED = ["id", "name", "scheduled", "venue", "league", "fights"]
        KEYS_EVENT = ["height", "weight", "reach", "stance", "first_name", "nick_name", "last_name", "record"]

      end
    end
  end
end

__END__


m = Sportradar::Api::Mma.new
sr = m.participants;
f = sr.fighters.sample;


m = Sportradar::Api::Mma.new
sc = m.schedule;
e = sc.events.sample;
e.fights.first.fighters.first.born

fighter_hash = {'id' => "259117dc-c443-4086-8c1d-abd082e3d4b9" } # => Conor McGregor
f = Sportradar::Api::Mma::Fighter.new(fighter_hash)
