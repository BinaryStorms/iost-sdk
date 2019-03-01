# frozen_string_literal: true

require 'iost_sdk/crypto'
require 'iost_sdk/models/query/signed_transaction'

RSpec.describe IOSTSdk::Models::Query::SignedTransaction do
  let(:query_tx_raw) {
    {
      'time' => 1548874098377000000,
      'expiration' => 1544013526179000000,
      'gas_ratio' => 1,
      'gas_limit' => 1234,
      'delay' => 0,
      'chain_id' => 0,
      'signers' => ['abc'],
      'actions' => [
        {
          'contract' => 'cont',
          'action_name' => 'abi',
          'data' => []
        }
      ],
      'amount_limit' => [
        {
          'token' => 'iost',
          'value' => 123
        }
      ],
      'signatures' => []
    }
  }

  let(:query_tx) {
    IOSTSdk::Models::Query::Transaction.new.populate(model_data: query_tx_raw)
  }

  it 'should create a valid instance from a transaction query' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    expect(signed_txn.is_a?(IOSTSdk::Models::Query::SignedTransaction)).to be_truthy
    expect(signed_txn.time).to eq(query_tx.time)
    expect(signed_txn.expiration).to eq(query_tx.expiration)
    expect(signed_txn.gas_ratio).to eq(query_tx.gas_ratio)
    expect(signed_txn.gas_limit).to eq(query_tx.gas_limit)
    expect(signed_txn.delay).to eq(query_tx.delay)
    expect(signed_txn.chain_id).to eq(query_tx.chain_id)
    expect(signed_txn.signers).to eq(query_tx.signers)
    expect(signed_txn.actions).to eq(query_tx.actions)
    expect(signed_txn.amount_limit).to eq(query_tx.amount_limit)
    expect(signed_txn.signatures).to eq(query_tx.signatures)
  end

  it 'should generate the expected hash' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    hex_value = signed_txn.send(:hash_value, include_signatures: false).unpack('H*').first
    expect(hex_value).to eq('12ee0dce3e7681ed44ea64de31eecdefb40370becd5344e36f69686432c5b00e')
  end

  it 'should generate the expected signature' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: '1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB')
    signed_txn = signed_txn.send(:add_sig, key_pair: key_pair)
    expect(signed_txn).not_to be_nil
    expect(signed_txn.signatures.size).to eq(1)
    expect(signed_txn.signatures.first.algorithm).to eq('ED25519')
    expect(signed_txn.signatures.first.public_key).to eq('VzGt610agH7JxDglOJ5e3/cEEuRkOpRimmUq8b/PLwg=')
    expect(signed_txn.signatures.first.signature).to eq('eKnLGSli2bch9dtsiL/z8g0ea6ATEvmRrw/NDDEgo3k8jDq4R7QJQwv8wdE+Y/YZ9SLVTgegj8TdNxkJCmGOAA==')
  end

  it 'should generate the expected publisher signature' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: '1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB')
    signed_txn = signed_txn.send(:add_sig, key_pair: key_pair)
    hash_for_publisher_sig = signed_txn.send(:hash_value, include_signatures: true)
    expect(hash_for_publisher_sig.unpack('H*').first).to eq('5c0131904eba13c739c2441e342da838857df4b22fd1d8e6e9cc866dfe33cddf')
    signed_txn = signed_txn.send(:add_publisher_sig, account_name: 'def', key_pair: key_pair)
    expect(signed_txn.publisher).to eq('def')
    expect(signed_txn.publisher_sigs.size).to eq(1)
    expect(signed_txn.publisher_sigs.first.algorithm).to eq('ED25519')
    expect(signed_txn.publisher_sigs.first.public_key).to eq('VzGt610agH7JxDglOJ5e3/cEEuRkOpRimmUq8b/PLwg=')
    expect(signed_txn.publisher_sigs.first.signature).to eq('Lk0VLtOy8dZ9PfOd8ZMoCYsdERQoS66/Jg+ycYAv7n9H7m6k/vRNu32iuQtnCSVIq2qHMnnXZo4loGp9qZqVCQ==')
  end

  it 'should sign the transaction correctly' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: '1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB')
    signed_txn.sign(account_name: 'def', key_pair: key_pair)
    expect(signed_txn.publisher).to eq('def')
    expect(signed_txn.publisher_sigs.size).to eq(1)
    expect(signed_txn.publisher_sigs.first.algorithm).to eq('ED25519')
    expect(signed_txn.publisher_sigs.first.public_key).to eq('VzGt610agH7JxDglOJ5e3/cEEuRkOpRimmUq8b/PLwg=')
    expect(signed_txn.publisher_sigs.first.signature).to eq('Lk0VLtOy8dZ9PfOd8ZMoCYsdERQoS66/Jg+ycYAv7n9H7m6k/vRNu32iuQtnCSVIq2qHMnnXZo4loGp9qZqVCQ==')
  end
end
