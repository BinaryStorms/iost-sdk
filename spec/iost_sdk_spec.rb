# frozen_string_literal: true

require 'json'
require 'iost_sdk'
require 'iost_sdk/crypto'

RSpec.describe IOSTSdk do
  it 'should create an instance with default values' do
    iost = IOSTSdk::Main.new(endpoint: testnet_url)
    expect(iost.gas_limit).to eq(2_000_000)
    expect(iost.gas_ratio).to eq(1)
    expect(iost.delay).to eq(0)
    expect(iost.expiration).to eq(90)
  end

  it 'should create a Transaction with an action' do
    txn = IOSTSdk::Main.new(endpoint: testnet_url)
                       .call_abi(
                         contract_id: 'contract-123',
                         abi_name: 'grow',
                         abi_args: {
                           rate: 0.8,
                           cap: 999
                         }
                       )
                       .transaction

    expect(txn.is_a?(IOSTSdk::Models::Query::Transaction)).to be_truthy
    expect(txn.actions.size).to eq(1)
    expect(txn.actions.first.contract).to eq('contract-123')
    expect(txn.actions.first.action_name).to eq('grow')
    expect(txn.actions.first.data).to eq(
      JSON.generate(
        rate: 0.8,
        cap: 999
      )
    )
    expect(txn.amount_limit.size).to eq(1)
    expect(txn.amount_limit.first.token).to eq('*')
    expect(txn.amount_limit.first.value).to eq('unlimited')
  end

  it 'should create a Transaction with a transfer action' do
    txn = IOSTSdk::Main.new(endpoint: testnet_url)
                       .transfer(
                         token: 'iron.man',
                         from: 'Tony',
                         to: 'Stark',
                         amount: 999,
                         memo: 'Hey, spend it well :-)'
                       )
                       .transaction
    expect(txn.is_a?(IOSTSdk::Models::Query::Transaction)).to be_truthy
    expect(txn.actions.size).to eq(1)
    expect(txn.actions.first.contract).to eq('token.iost')
    expect(txn.actions.first.action_name).to eq('transfer')
    expect(txn.actions.first.data).to eq(
      JSON.generate(['iron.man', 'Tony', 'Stark', 999, 'Hey, spend it well :-)'])
    )
    expect(txn.amount_limit.size).to eq(2)
    expect(txn.amount_limit.first.token).to eq('*')
    expect(txn.amount_limit.first.value).to eq('unlimited')
    expect(txn.amount_limit[1].token).to eq('iost')
    expect(txn.amount_limit[1].value).to eq('999')
  end

  it 'should create a Transaction with a new_account action' do
    key_pair = IOSTSdk::Crypto.keypair_from_private_key(
      algo: 'ED25519',
      encoded_private_key: '84bcoQzCg2HgyAosknAN1XW97Sp2R4UJLZxqUUmnh5p1'
    )

    new_account_args = {
      name: 'IronMan',
      creator: 'admin',
      owner_key: key_pair,
      active_key: key_pair,
      initial_ram: 5_000,
      initial_gas_pledge: 10_000
    }

    txn = IOSTSdk::Main.new(endpoint: testnet_url)
                       .new_account(new_account_args)
                       .transaction
    expect(txn.is_a?(IOSTSdk::Models::Query::Transaction)).to be_truthy
    expect(txn.actions.size).to eq(3)

    expect(txn.expiration).to eq(txn.time + 90 * 1_000_000_000)
    expect(txn.amount_limit.size).to eq(1)
    expect(txn.amount_limit.first.token).to eq('*')
    expect(txn.amount_limit.first.value).to eq('unlimited')
  end

  describe 'read APIs' do
    let(:iost) { IOSTSdk::Main.new(endpoint: testnet_url) }

    before(:all) {
      @test_data = {}
    }

    it '/getNodeInfo should succeed' do
      node_info = iost.get_node_info
      expect(node_info).not_to be_nil
      expect(node_info.is_a?(IOSTSdk::Models::NodeInfo)).to be_truthy
    end

    it '/getChainInfo should succeed' do
      chain_info = iost.get_chain_info
      @test_data[:block_number] = chain_info.lib_block
      @test_data[:block_hash] = chain_info.lib_block_hash
      expect(chain_info).not_to be_nil
      expect(chain_info.is_a?(IOSTSdk::Models::ChainInfo)).to be_truthy
    end

    it '/getGasRatio should succeed' do
      gas_ratio = iost.get_gas_ratio
      expect(gas_ratio).not_to be_nil
      expect(gas_ratio.is_a?(IOSTSdk::Models::GasRatio)).to be_truthy
    end

    it '/getRAMInfo should succeed' do
      ram_info = iost.get_ram_info
      expect(ram_info).not_to be_nil
      expect(ram_info.is_a?(IOSTSdk::Models::RAMInfo)).to be_truthy
    end

    it '/getBlockByNumber should succeed' do
      block_info = iost.get_block_by_number(number: @test_data[:block_number], complete: true)
      expect(block_info).not_to be_nil
      expect(block_info.is_a?(IOSTSdk::Models::BlockInfo)).to be_truthy
      @test_data[:transactions] = block_info.block.transactions
      @test_data[:contract_name] = @test_data[:transactions].first.actions.first.contract
    end

    it '/getBlockByHash should succeed' do
      block_info = iost.get_block_by_hash(hash_value: @test_data[:block_hash], complete: true)
      expect(block_info).not_to be_nil
      expect(block_info.is_a?(IOSTSdk::Models::BlockInfo)).to be_truthy
      expect(block_info.block.number).to eq(@test_data[:block_number])
    end

    it '/getTxByHash should succeed' do
      tx_info = iost.get_tx_by_hash(hash_value: @test_data[:transactions].first.hash)
      expect(tx_info).not_to be_nil
      expect(tx_info.is_a?(IOSTSdk::Models::TransactionInfo)).to be_truthy
    end

    it '/getTxReceiptByHash should succeed' do
      tx_receipt = iost.get_tx_receipt_by_tx_hash(hash_value: @test_data[:transactions].first.hash)
      expect(tx_receipt).not_to be_nil
      expect(tx_receipt.is_a?(IOSTSdk::Models::TxReceipt)).to be_truthy
      @test_data[:account_name] = JSON.parse(tx_receipt.receipts.first.content)[1]
    end

    it '/getAccount should succeed' do
      account = iost.get_account(name: @test_data[:account_name], by_longest_chain: true)
      expect(account).not_to be_nil
      expect(account.is_a?(IOSTSdk::Models::Account)).to be_truthy
    end

    it '/getTokenBalance should succeed' do
      token_balance = iost.get_token_balance(account_name: @test_data[:account_name], token_name: 'iost', by_longest_chain: true)
      expect(token_balance).not_to be_nil
      expect(token_balance.is_a?(IOSTSdk::Models::TokenBalance)).to be_truthy
    end

    it '/getContract should succeed' do
      contract = iost.get_contract(id: @test_data[:contract_name], by_longest_chain: true)
      expect(contract).not_to be_nil
      expect(contract.is_a?(IOSTSdk::Models::Contract)).to be_truthy
    end

    it '/getContractStorage should succeed' do
      query = IOSTSdk::Models::Query::ContractStorage.new.populate(
        model_data: {
          'id' => @test_data[:contract_name],
          'field' => 'producer002',
          'key' => 'producerTable',
          'by_longest_chain' => true
        }
      )
      contract_storage = iost.get_contract_storage(query: query)
      expect(contract_storage).not_to be_nil
      expect(contract_storage.is_a?(Hash)).to be_truthy
      expect(contract_storage.has_key?(:data)).to be_truthy
    end

    it '/getContractStorageFields should succeed' do
      query = IOSTSdk::Models::Query::ContractStorageFields.new.populate(
        model_data: {
          'id' => @test_data[:contract_name],
          'key' => 'producerTable',
          'by_longest_chain' => true
        }
      )
      contract_storage_fields = iost.get_contract_storage_fields(query: query)
      expect(contract_storage_fields).not_to be_nil
      expect(contract_storage_fields.is_a?(Hash)).to be_truthy
      expect(contract_storage_fields.has_key?(:fields)).to be_truthy
    end
  end

  describe 'transactions' do
    let(:key_pair) do
      IOSTSdk::Crypto.from_keypair(
        encoded_keypair: '3uwDfYMnqh2WyNUiU6WWFUTYuVEXGtQeECzMq9Q9pigmtUBZK1s4WBw7JGWukgCUysayMUF6irvc47WHEQLiWixL'
      )
    end

    it 'should send a "new account" transaction correctly' do
      iost = IOSTSdk::Main.new(endpoint: testnet_url)
                         .new_account(
                           name: 'ironman',
                           creator: 'binary_test',
                           owner_key: key_pair,
                           active_key: key_pair,
                           initial_ram: 10,
                           initial_gas_pledge: 0
                         )
      iost.transaction.chain_id = 1023
      resp = iost.sign_and_send(account_name: 'binary_test', key_pair: key_pair)
      expect(resp[:status]).to eq('failed')
      expect(resp[:txn_hash]).to_not be_nil
    end

    it 'should send a "callABI" transaction correctly' do
      iost = IOSTSdk::Main.new(endpoint: testnet_url)
                          .call_abi(
                            contract_id: 'token.iost',
                            abi_name: 'transfer',
                            abi_args: ['iost', 'binary_test', 'binary_test', '10.000', '']
                          )
      iost.transaction.chain_id = 1023
      resp = iost.sign_and_send(account_name: 'binary_test', key_pair: key_pair)
      expect(resp[:status]).to eq('success')
      expect(resp[:txn_hash]).to_not be_nil
    end

    it 'should send a "transfer" transaction correctly' do
      iost = IOSTSdk::Main.new(endpoint: testnet_url)
                          .transfer(
                            token: 'iost',
                            from: 'binary_test',
                            to: 'binary_test',
                            amount: '10.000',
                            memo: 'this is a test'
                          )
      iost.transaction.chain_id = 1023
      resp = iost.sign_and_send(account_name: 'binary_test', key_pair: key_pair)
      expect(resp[:status]).to eq('success')
      expect(resp[:txn_hash]).to_not be_nil
    end
  end
end
