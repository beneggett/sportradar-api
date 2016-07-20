module Sportradar
  module Api
    class Data

      # Attributes that have a value
      def attributes
        all_attributes.select {|x| !self.send(x).nil? }
      end

      def all_attributes
        self.instance_variables.map{|attribute| attribute.to_s.gsub('@', '').to_sym }
      end

    end

  end
end
