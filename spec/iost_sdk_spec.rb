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
    expect(txn.is_a?(IOSTSdk::Models::Query::Transaction)).to be_truthy
    expect(txn.actions.size).to eq(3)

    expect(txn.expiration).to eq(txn.time + 90 * 1_000_000_000)
    expect(txn.amount_limit.size).to eq(1)
    expect(txn.amount_limit.first.token).to eq('*')
    expect(txn.amount_limit.first.value).to eq('unlimited')
  end
end
