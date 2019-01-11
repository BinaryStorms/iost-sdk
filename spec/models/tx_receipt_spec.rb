# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/tx_receipt'
require 'iost_sdk/models/receipt'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::TxReceipt do
  describe 'when deserialization is successful' do
    let(:tx_receipt_data) do
      {
        'tx_hash' => '6eGkZoXPQtYXdh7dBSXe2L1ckUCDj4egRn4fXtS2ACnR',
        'gas_usage' => 6633,
        'ram_usage' => {
          'admin' => '0',
          'issue.iost' => '0'
        },
        'status_code' => 'SUCCESS',
        'message' => '',
        'returns' => [[]],
        'receipts' => [{
          'func_name' => 'token.iost/transfer',
          'content' => ['iost', 'admin', 'i1544269477', '1', '']
        }]
      }
    end

    it 'should return a valid TxReceipt instance' do
      tx_receipt = IOSTSdk::Models::TxReceipt.new.populate(model_data: tx_receipt_data)
      expect(tx_receipt).not_to be_nil
      expect(tx_receipt.tx_hash).to eq(tx_receipt_data['tx_hash'])
      expect(tx_receipt.gas_usage).to eq(tx_receipt_data['gas_usage'])
      expect(tx_receipt.ram_usage).to eq(tx_receipt_data['ram_usage'])
      expect(tx_receipt.status_code).to eq(tx_receipt_data['status_code'])
      expect(tx_receipt.message).to eq(tx_receipt_data['message'])
      expect(tx_receipt.returns).to eq(tx_receipt_data['returns'])
      # Receipt
      expect(tx_receipt.receipts.is_a?(Array)).to be_truthy
      expect(tx_receipt.receipts.first.is_a?(IOSTSdk::Models::Receipt)).to be_truthy
      expect(tx_receipt.receipts.size).to eq(1)
      expect(tx_receipt.receipts.first.func_name).to eq(tx_receipt_data['receipts'].first['func_name'])
      expect(tx_receipt.receipts.first.content).to eq(tx_receipt_data['receipts'].first['content'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::TxReceipt.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
