module Sportradar
  module Api
    module Baseball
      class Runner < Data
        attr_accessor :response, :id, :starting_base, :ending_base, :outcome_id, :out, :description, :fielders, :outcome

        def initialize(data, **opts)
          @response = data
          # @game     = opts[:game]

          update(data)
        end
        def update(data, **opts)
          @id             = data["id"]
          @starting_base  = data["starting_base"]
          @ending_base    = data["ending_base"]
          @outcome_id     = data["outcome_id"]
          @outcome        = runner_outcome(@outcome_id)
          @out            = data["out"]
          @last_name      = data["last_name"]
          @first_name     = data["first_name"]
          @preferred_name = data["preferred_name"]
          @jersey_number  = data["jersey_number"]
          @description    = data['description']
          @fielders       = data['fielders'].map { |hash| Fielder.new(hash) } if data['fielders']
        end

        def runner_outcome(code)
          runner_outcomes[code]
        end
        def runner_outcomes
          @runner_outcomes ||= {
            'CK'     => 'Checked',
            'ERN'    => 'Earned Run/RBI',
            'eRN'    => 'Earned Run/No RBI',
            'URN'    => 'Unearned Run/RBI',
            'uRN'    => 'Unearned Run/No RBI',
            'PO'     => 'Pickoff',
            'POCS2'  => 'Pickoff/Caught Stealing 2nd',
            'POCS3'  => 'Pickoff/Caught Stealing 3nd',
            'POCS4'  => 'Pickoff/Caught Stealing Home',
            'AD1'    => 'Advance 1st',
            'AD2'    => 'Advance 2nd',
            'AD3'    => 'Advance 3rd',
            'SB2'    => 'Stole 2nd',
            'SB2E4E' => 'Stole 2nd, error to home (earned)',
            'SB3'    => 'Stole 3rd',
            'SB3E4E' => 'Stole 3rd, error to home (earned)',
            'SB4'    => 'Stole Home',
            'TO2'    => 'Tag out 2nd',
            'TO3'    => 'Tag out 3rd',
            'TO4'    => 'Tag out Home',
            'FO1'    => 'Force out 1st',
            'FO2'    => 'Force out 2nd',
            'FO3'    => 'Force out 3rd',
            'FO4'    => 'Force out Home',
            'CS2'    => 'Caught Stealing 2nd',
            'CS3'    => 'Caught Stealing 3rd',
            'CS4'    => 'Caught Stealing Home',
            'SB2E3'  => 'Stole 2nd, error to 3rd',
            'SB2E4'  => 'Stole 2nd, error to Home',
            'SB3E4'  => 'Stole 3nd, error to Home',
            'DI2'    => 'Indifference to 2nd',
            'DI3'    => 'Indifference to 3rd',
            'DO1'    => 'Doubled off 1st',
            'DO2'    => 'Doubled off 2nd',
            'DO3'    => 'Doubled off 3rd',
            'RI'     => 'Runner Interference',
            'OOA'    => 'Out on Appeal',
            'OBP'    => 'Out of Base Path',
            'HBB'    => 'Hit by Batted Ball',
          }
        end

      end
    end
  end
end
