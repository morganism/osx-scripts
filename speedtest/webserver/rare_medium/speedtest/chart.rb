# rare_medium/speedtest/chart.rb

module RareMedium
  module Speedtest
    class Chart
      def self.generate(data)
        raise NotImplementedError, 'Subclasses must implement the generate method'
      end
    end
  end
end

