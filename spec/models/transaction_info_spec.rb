# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/transaction_info'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::TransactionInfo do
  describe 'when deserialization is successful' do
    let(:transaction_info_data) do
      {
        'status' => 'IRREVERSIBLE',
        'transaction' => {
          'hash' => '6eGkZoXPQtYXdh7dBSXe2L1ckUCDj4egRn4fXtS2ACnR',
          'time' => '1544269519362042000',
          'expiration' => '1544279519362041000',
          'gas_ratio' => 1,
          'gas_limit' => 50000,
          'delay' => '0',
          'actions' => [{
            'contract' => 'ContractTBv8ZDKUhTyeS4MomdcHRrXnJMELa5usSMHP6QJntFQ',
            'action_name' => 'transfer',
            'data' => ['admin', 'i1544269477', 1]
          }],
          'signers' => [],
          'publisher' => 'admin',
          'referred_tx' => '',
          'amount_limit' => [],
          'tx_receipt' => nil
        }
      }
    end

    it 'should return a valid TransactionInfo instance' do
      transaction_info = IOSTSdk::Models::TransactionInfo.new.populate(model_data: transaction_info_data)
      expect(transaction_info).not_to be_nil
      expect(transaction_info.status).to eq(transaction_info_data['status'])
      # Transaction
      expect(transaction_info.transaction.is_a?(IOSTSdk::Models::Transaction)).to be_truthy
      expect(transaction_info.transaction.hash).to eq(transaction_info_data['transaction']['hash'])
      expect(transaction_info.transaction.time).to eq(transaction_info_data['transaction']['time'])
      expect(transaction_info.transaction.expiration).to eq(transaction_info_data['transaction']['expiration'])
      expect(transaction_info.transaction.gas_ratio).to eq(transaction_info_data['transaction']['gas_ratio'])
      expect(transaction_info.transaction.gas_limit).to eq(transaction_info_data['transaction']['gas_limit'])
      expect(transaction_info.transaction.delay).to eq(transaction_info_data['transaction']['delay'])
      expect(transaction_info.transaction.signers).to eq(transaction_info_data['transaction']['signers'])
      expect(transaction_info.transaction.publisher).to eq(transaction_info_data['transaction']['publisher'])
      expect(transaction_info.transaction.referred_tx).to eq(transaction_info_data['transaction']['referred_tx'])
      # Action
      expect(transaction_info.transaction.actions.is_a?(Array)).to be_truthy
      expect(transaction_info.transaction.actions.first.is_a?(IOSTSdk::Models::Action)).to be_truthy
      expect(transaction_info.transaction.actions.first.contract).to eq(transaction_info_data['transaction']['actions'].first['contract'])
      expect(transaction_info.transaction.actions.first.action_name).to eq(transaction_info_data['transaction']['actions'].first['action_name'])
      expect(transaction_info.transaction.actions.first.data).to eq(transaction_info_data['transaction']['actions'].first['data'])
      # AmountLimit
      expect(transaction_info.transaction.amount_limit.is_a?(Array)).to be_truthy
      expect(transaction_info.transaction.amount_limit.empty?).to be_truthy
      # TxReceipt
      expect(transaction_info.transaction.tx_receipt).to be_nil
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::TransactionInfo.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
