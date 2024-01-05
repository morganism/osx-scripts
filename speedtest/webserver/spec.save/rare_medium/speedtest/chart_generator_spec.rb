# spec/rare_medium/speedtest/chart_generator_spec.rb

require 'spec_helper'
require 'rare_medium/speedtest/chart_generator'

RSpec.describe RareMedium::Speedtest::ChartGenerator do
  describe '.generate_chart' do
    it 'generates a bar chart by default' do
      data = [{ 'download' => 10, 'upload' => 15 }, { 'download' => 20, 'upload' => 25 }]

      expect(RareMedium::Speedtest::Bar).to receive(:generate).with(data)

      described_class.generate_chart(data)
    end

    it 'generates the specified chart type' do
      data = [{ 'download' => 10, 'upload' => 15 }, { 'download' => 20, 'upload' => 25 }]

      expect(RareMedium::Speedtest::Line).to receive(:generate).with(data)

      described_class.generate_chart(data, :line)
    end

    it 'handles invalid chart type gracefully' do
      data = [{ 'download' => 10, 'upload' => 15 }, { 'download' => 20, 'upload' => 25 }]

      expect { described_class.generate_chart(data, :invalid_chart_type) }.to output(/Invalid chart type/).to_stdout
    end
  end
end

