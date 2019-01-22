# frozen_string_literal: true

require 'json'
require 'iost_sdk/http/client'
require 'iost_sdk/models/query/contract_storage_query'
require 'iost_sdk/models/query/contract_storage_fields_query'

RSpec.describe IOSTSdk::Http::Client do
  describe 'all API call methods' do
    let(:base_url) { 'http://13.52.105.102:30001' }
    let(:client) { IOSTSdk::Http::Client.new(base_url: base_url) }

    before(:all) {
      @test_data = {}
    }

    it '/getNodeInfo should succeed' do
      node_info = client.get_node_info
      expect(node_info).not_to be_nil
      expect(node_info.is_a?(IOSTSdk::Models::NodeInfo)).to be_truthy
    end

    it '/getChainInfo should succeed' do
      chain_info = client.get_chain_info
      @test_data[:block_number] = chain_info.lib_block
      @test_data[:block_hash] = chain_info.lib_block_hash
      expect(chain_info).not_to be_nil
      expect(chain_info.is_a?(IOSTSdk::Models::ChainInfo)).to be_truthy
    end

    it '/getGasRatio should succeed' do
      gas_ratio = client.get_gas_ratio
      expect(gas_ratio).not_to be_nil
      expect(gas_ratio.is_a?(IOSTSdk::Models::GasRatio)).to be_truthy
    end

    it '/getRAMInfo should succeed' do
      ram_info = client.get_ram_info
      expect(ram_info).not_to be_nil
      expect(ram_info.is_a?(IOSTSdk::Models::RAMInfo)).to be_truthy
    end

    it '/getBlockByNumber should succeed' do
      block_info = client.get_block_by_number(number: @test_data[:block_number], complete: true)
      expect(block_info).not_to be_nil
      expect(block_info.is_a?(IOSTSdk::Models::BlockInfo)).to be_truthy
      @test_data[:transactions] = block_info.block.transactions
      @test_data[:contract_name] = @test_data[:transactions].first.actions.first.contract
    end

    it '/getBlockByHash should succeed' do
      block_info = client.get_block_by_hash(hash_value: @test_data[:block_hash], complete: true)
      expect(block_info).not_to be_nil
      expect(block_info.is_a?(IOSTSdk::Models::BlockInfo)).to be_truthy
      expect(block_info.block.number).to eq(@test_data[:block_number])
    end

    it '/getTxByHash should succeed' do
      tx_info = client.get_tx_by_hash(hash_value: @test_data[:transactions].first.hash)
      expect(tx_info).not_to be_nil
      expect(tx_info.is_a?(IOSTSdk::Models::TransactionInfo)).to be_truthy
    end

    it '/getTxReceiptByHash should succeed' do
      tx_receipt = client.get_tx_receipt_by_tx_hash(hash_value: @test_data[:transactions].first.hash)
      expect(tx_receipt).not_to be_nil
      expect(tx_receipt.is_a?(IOSTSdk::Models::TxReceipt)).to be_truthy
      @test_data[:account_name] = JSON.parse(tx_receipt.receipts.first.content)[1]
    end

    it '/getAccount should succeed' do
      account = client.get_account(name: @test_data[:account_name], by_longest_chain: true)
      expect(account).not_to be_nil
      expect(account.is_a?(IOSTSdk::Models::Account)).to be_truthy
    end

    it '/getTokenBalance should succeed' do
      token_balance = client.get_token_balance(account_name: @test_data[:account_name], token_name: 'iost', by_longest_chain: true)
      expect(token_balance).not_to be_nil
      expect(token_balance.is_a?(IOSTSdk::Models::TokenBalance)).to be_truthy
    end

    it '/getContract should succeed' do
      contract = client.get_contract(id: @test_data[:contract_name], by_longest_chain: true)
      expect(contract).not_to be_nil
      expect(contract.is_a?(IOSTSdk::Models::Contract)).to be_truthy
    end

    it '/getContractStorage should succeed' do
      query = IOSTSdk::Models::Query::ContractStorageQuery.new.populate(
        model_data: {
          'id' => @test_data[:contract_name],
          'field' => 'producer002',
          'key' => 'producerTable',
          'by_longest_chain' => true
        }
      )
      contract_storage = client.get_contract_storage(query: query)
      expect(contract_storage).not_to be_nil
      expect(contract_storage.is_a?(Hash)).to be_truthy
      expect(contract_storage.has_key?(:data)).to be_truthy
    end

    it '/getContractStorageFields should succeed' do
      query = IOSTSdk::Models::Query::ContractStorageFieldsQuery.new.populate(
        model_data: {
          'id' => @test_data[:contract_name],
          'key' => 'producerTable',
          'by_longest_chain' => true
        }
      )
      contract_storage_fields = client.get_contract_storage_fields(query: query)
      expect(contract_storage_fields).not_to be_nil
      expect(contract_storage_fields.is_a?(Hash)).to be_truthy
      expect(contract_storage_fields.has_key?(:fields)).to be_truthy
    end
  end
end
