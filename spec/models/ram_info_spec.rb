# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/ram_info'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::RAMInfo do
  describe 'when deserialization is successful' do
    let(:ram_info_data) do
      {
        'available_ram' => '96207067431',
        'buy_price' => 0.04227129323234719,
        'sell_price' => 0.00014551844642842057,
        'total_ram' => '137438953472',
        'used_ram' => '41231886041'
      }
    end

    it 'should return a valid RAMInfo instance' do
      ram_info = IOSTSdk::Models::RAMInfo.new.populate(model_data: ram_info_data)
      expect(ram_info).not_to be_nil
      expect(ram_info.available_ram).to eq(ram_info_data['available_ram'])
      expect(ram_info.buy_price).to eq(ram_info_data['buy_price'])
      expect(ram_info.sell_price).to eq(ram_info_data['sell_price'])
      expect(ram_info.total_ram).to eq(ram_info_data['total_ram'])
      expect(ram_info.used_ram).to eq(ram_info_data['used_ram'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::RAMInfo.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
