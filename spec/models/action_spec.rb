# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/action'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::Action do
  describe 'when deserialization is successful' do
    let(:action_data) do
      {
        'contract' => 'ContractTBv8ZDKUhTyeS4MomdcHRrXnJMELa5usSMHP6QJntFQ',
        'action_name' => 'transfer',
        'data' => ['admin', 'i1544269477', 1]
      }
    end

    it 'should return a valid Action instance' do
      action = IOSTSdk::Models::Action.new.populate(model_data: action_data)
      expect(action).not_to be_nil
      expect(action.contract).to eq(action_data['contract'])
      expect(action.action_name).to eq(action_data['action_name'])
      expect(action.data).to eq(action_data['data'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::Action.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
