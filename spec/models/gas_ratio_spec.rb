# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/gas_ratio'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::GasRatio do
  describe 'when deserialization is successful' do
    let(:gas_ratio_data) do
      {
        'lowest_gas_ratio' => 1.5,
        'median_gas_ratio' => 1.76
      }
    end

    it 'should return a valid GasRatio instance' do
      gas_ratio = IOSTSdk::Models::GasRatio.new.populate(model_data: gas_ratio_data)
      expect(gas_ratio).not_to be_nil
      expect(gas_ratio.lowest_gas_ratio).to eq(gas_ratio_data['lowest_gas_ratio'])
      expect(gas_ratio.median_gas_ratio).to eq(gas_ratio_data['median_gas_ratio'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::GasRatio.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
