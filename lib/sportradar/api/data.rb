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

      def parse_into_array(selector: , klass: )
        if selector.is_a?(Array)
          selector.map {|x| klass.new x }
        elsif selector.is_a?(Hash)
          [ klass.new(selector) ]
        end
      end
      def parse_into_array_with_options(selector: , klass: , **opts)
        if selector.is_a?(Array)
          selector.map {|x| klass.new(x, **opts) }
        elsif selector.is_a?(Hash)
          [ klass.new(selector, **opts) ]
        else
          []
        end
      end

      def structure_links(links_arr)
        links_arr.map { |hash| [hash['rel'], hash['href'].gsub('.xml', '')] }.to_h
      end

      # @param existing [Hash{String=>Data}] Existing data hash, ID => entity
      # @param data [Hash, Array] new data to update with
      def update_data(existing, data)
        case data
        when Array
          data.each { |hash| existing[hash['id']].update(hash) }
        when Hash
          existing[data['id']].update(data)
        else
          # raise
        end
        existing
      end

      # @param existing [Hash{String=>Data}] Existing data hash, ID => entity
      # @param data [Hash, Array] new data to update with
      def create_data(existing = {}, data, klass: nil, identifier: 'id', **opts)
        existing ||= {} # handles nil case, typically during object instantiation
        case data
        when [], {}
          existing
        when Array
          data.each do |hash|
            current = existing[hash[identifier]]
            if current
              current.update(hash, **opts)
            else
              current = klass.new(hash, **opts)
              existing[current.id] = current
            end
            existing[current.id]
          end
        when Hash
          existing[data[identifier]] ||= klass.new(data, **opts)
          existing[data[identifier]].update(data, **opts)
        else
          # raise
        end
        existing
      end

      def parse_out_hashes(data_element)
        if data_element && data_element.is_a?(Array)
          data_element.find {|elem| elem.is_a?(Hash) }
        else
          data_element
        end
      end

    end

  end
end
