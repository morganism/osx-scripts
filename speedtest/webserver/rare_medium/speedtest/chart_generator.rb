# rare_medium/speedtest/chart_generator.rb

module RareMedium
  module Speedtest
    class ChartGenerator
      CHART_TYPES = %i[bar stacked_bar line scatter pie].freeze

      def self.generate_chart(data, chart_type = :bar)
        unless CHART_TYPES.include?(chart_type)
          puts "Invalid chart type. Available types: #{CHART_TYPES.join(', ')}"
          return
        end

        chart_class = Object.const_get("RareMedium::Speedtest::#{chart_type.capitalize}")
        chart_class.generate(data)
      end
    end
  end
end

