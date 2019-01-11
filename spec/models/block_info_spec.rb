# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/block_info'
require 'iost_sdk/models/block'
require 'iost_sdk/models/info'
require 'iost_sdk/models/transaction'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::BlockInfo do
  describe 'when deserialization is successful' do
    let(:block_info_data) do
      {
        'status' => 'IRREVERSIBLE',
        'block' => {
          'hash' => '4c9GHyGLi6hUqB4d6zGFcywycYKucsmWsbgvhPe31GaY',
          'version' => '0',
          'parent_hash' => 'G4njPLnYskU4DcuTz5CwpLPETcfH6yN78V8emge8t21f',
          'tx_merkle_hash' => 'HHKAG2D7Kon2on5SqV66ZsfdNk9Wus8yhWqdTb86wgPJ',
          'tx_receipt_merkle_hash' => 'FXr8Mf7hr568MP23BFWJiBUej2xSj3M7416WAKJpswzx',
          'number' => '2',
          'witness' => 'IOST2YKPmRDGy5xLR7Gv65CN5nQ3vMmVhRjAsEM7Gj9xcB1LWgZUAd',
          'time' => '1544262978309033000',
          'gas_usage' => 0,
          'tx_count' => '1',
          'info' => nil,
          'transactions' => []
        }
      }
    end

    it 'should return a valid BlockInfo instance' do
      block_info = IOSTSdk::Models::BlockInfo.new.populate(model_data: block_info_data)
      expect(block_info).not_to be_nil
      expect(block_info.status).to eq(block_info_data['status'])
      # Block
      expect(block_info.block.is_a?(IOSTSdk::Models::Block)).to be_truthy
      expect(block_info.block.hash).to eq(block_info_data['block']['hash'])
      expect(block_info.block.version).to eq(block_info_data['block']['version'])
      expect(block_info.block.parent_hash).to eq(block_info_data['block']['parent_hash'])
      expect(block_info.block.tx_merkle_hash).to eq(block_info_data['block']['tx_merkle_hash'])
      expect(block_info.block.tx_receipt_merkle_hash).to eq(block_info_data['block']['tx_receipt_merkle_hash'])
      expect(block_info.block.witness).to eq(block_info_data['block']['witness'])
      expect(block_info.block.time).to eq(block_info_data['block']['time'])
      expect(block_info.block.gas_usage).to eq(block_info_data['block']['gas_usage'])
      expect(block_info.block.tx_count).to eq(block_info_data['block']['tx_count'])
      expect(block_info.block.info).to eq(block_info_data['block']['info'])
      # Transaction
      expect(block_info.block.transactions.is_a?(Array)).to be_truthy
      expect(block_info.block.transactions.empty?).to be_truthy
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::BlockInfo.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
