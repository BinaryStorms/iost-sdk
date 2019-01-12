# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/transaction_request'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::TransactionRequest do
  describe 'when deserialization is successful' do
    let(:transaction_request_data) do
      {
        'time' => 1544709662543340000,
        'expiration' => 1544709692318715000,
        'gas_ratio' => 1,
        'gas_limit' => 50000,
        'delay' => 0,
        'signers' => [],
        'actions' => [
          {
            'contract' => 'token.iost',
            'action_name' => 'transfer',
            'data' => ['iost', 'testaccount', 'anothertest', '100', 'this is an example transfer']
          }
        ],
        'amount_limit' => [],
        'signatures' => [],
        'publisher' => 'testaccount',
        'publisher_sigs' => [
          {
            'algorithm' => 'ED25519',
            'public_key' => '9RhdenfTcEsg93gKvRccFYICaug+H0efBpOFLwafERQ=',
            'signature' => 'OCc68Q7Jq7DCZ2TP3yGQtWew/JmVzIFSlSOVgcRqQF9u6H3AKmKjuQi1SRtiT/HgmK04cze5XKnkgjXE8uAoAg=='
          }
        ]
      }
    end

    it 'should return a valid TransactionRequest instance' do
      transaction_request = IOSTSdk::Models::TransactionRequest.new.populate(model_data: transaction_request_data)
      expect(transaction_request).not_to be_nil
      expect(transaction_request.time).to eq(transaction_request_data['time'])
      expect(transaction_request.expiration).to eq(transaction_request_data['expiration'])
      expect(transaction_request.gas_ratio).to eq(transaction_request_data['gas_ratio'])
      expect(transaction_request.gas_limit).to eq(transaction_request_data['gas_limit'])
      expect(transaction_request.delay).to eq(transaction_request_data['delay'])
      expect(transaction_request.signers).to eq(transaction_request_data['signers'])
      expect(transaction_request.publisher).to eq(transaction_request_data['publisher'])
      # Action
      expect(transaction_request.actions.is_a?(Array)).to be_truthy
      expect(transaction_request.actions.size).to eq(1)
      expect(transaction_request.actions.first.contract).to eq(transaction_request_data['actions'][0]['contract'])
      expect(transaction_request.actions.first.action_name).to eq(transaction_request_data['actions'][0]['action_name'])
      expect(transaction_request.actions.first.data).to eq(transaction_request_data['actions'][0]['data'])
      # AmountLimit
      expect(transaction_request.amount_limit.is_a?(Array)).to be_truthy
      expect(transaction_request.amount_limit.empty?).to be_truthy
      # Signature - signatures
      expect(transaction_request.signatures.is_a?(Array)).to be_truthy
      expect(transaction_request.signatures.empty?).to be_truthy
      # Signature - publisher_sigs
      expect(transaction_request.publisher_sigs.is_a?(Array)).to be_truthy
      expect(transaction_request.publisher_sigs.size).to eq(1)
      expect(transaction_request.publisher_sigs.first.is_a?(IOSTSdk::Models::Signature)).to be_truthy
      expect(transaction_request.publisher_sigs.first.algorithm).to eq(transaction_request_data['publisher_sigs'][0]['algorithm'])
      expect(transaction_request.publisher_sigs.first.public_key).to eq(transaction_request_data['publisher_sigs'][0]['public_key'])
      expect(transaction_request.publisher_sigs.first.signature).to eq(transaction_request_data['publisher_sigs'][0]['signature'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::TransactionRequest.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
