# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/token_balance'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::TokenBalance do
  describe 'when deserialization is successful' do
    let(:token_balance_data) do
      {
        'balance' => 982678652,
        'frozen_balances' => []
      }
    end

    it 'should return a valid TokenBalance instance' do
      token_balance = IOSTSdk::Models::TokenBalance.new.populate(model_data: token_balance_data)
      expect(token_balance).not_to be_nil
      expect(token_balance.balance).to eq(token_balance_data['balance'])
      # FrozenBalance
      expect(token_balance.frozen_balances.empty?).to be_truthy
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::TokenBalance.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
