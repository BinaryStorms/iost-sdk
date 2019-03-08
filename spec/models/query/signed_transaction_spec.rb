# frozen_string_literal: true

require 'iost_sdk/crypto'
require 'iost_sdk/models/query/signed_transaction'

RSpec.describe IOSTSdk::Models::Query::SignedTransaction do
  let(:query_tx_raw) {
    {
      'time' => 1544013436179000000,
      'expiration' => 1544013526179000000,
      'gas_ratio' => 1,
      'gas_limit' => 1234,
      'delay' => 0,
      'chain_id' => 0,
      'reserved' => nil,
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

  it 'should generate the expected signature' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: '1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB')
    signed_txn = signed_txn.send(:add_sig, key_pair: key_pair)
    expect(signed_txn).not_to be_nil
    expect(signed_txn.signatures.size).to eq(1)
    expect(signed_txn.signatures.first.algorithm).to eq('ED25519')
    expect(signed_txn.signatures.first.public_key).to eq('VzGt610agH7JxDglOJ5e3/cEEuRkOpRimmUq8b/PLwg=')
    expect(signed_txn.signatures.first.signature).to eq('xBK4javwhCSqqn1adc8/tGNolw560OZb9xFGRrY6O3lnU9oULoa+ZL/SVsb1+zloiNatEsHkyApKKO2s9e0IAg==')

    txn_signature_bytes = signed_txn.send(:bytes_for_signature)
    expect(txn_signature_bytes.pack('C*').unpack('H*').first)
      .to eq('156d700a27e12ac0156d701f1c4c2ec00000000000000064000000000001e208000000000000000000000000000000000000000100000003616263000000010000001500000004636f6e7400000003616269000000025b5d000000010000000f00000004696f737400000003313233')
    expect(SHA3::Digest.new(:sha256).update(txn_signature_bytes.pack('C*')).digest.unpack('H*').first)
      .to eq('95e01835fb9901c26716d73884cc96342dfb2d68e48fb165e95edf6618228e4d')
  end

  it 'should generate the expected publisher signature' do
    signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: query_tx)
    key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: '1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB')
    signed_txn = signed_txn.send(:add_sig, key_pair: key_pair)
    hash_for_publisher_sig = signed_txn.send(:hash_value, include_signatures: true)
    expect(hash_for_publisher_sig.unpack('H*').first).to eq('8bbac0feae2de2875046de2f20001a59e6f8d5a40af5d133bb7a8150043501e0')
    signed_txn = signed_txn.send(:add_publisher_sig, account_name: 'def', key_pair: key_pair)
    expect(signed_txn.publisher).to eq('def')
    expect(signed_txn.publisher_sigs.size).to eq(1)
    expect(signed_txn.publisher_sigs.first.algorithm).to eq('ED25519')
    expect(signed_txn.publisher_sigs.first.public_key).to eq('VzGt610agH7JxDglOJ5e3/cEEuRkOpRimmUq8b/PLwg=')
    expect(signed_txn.publisher_sigs.first.signature).to eq('nN72xc+yZqjDjAOXFm7b1uiw6E9/324oOE3Ut8FsioO7n5Ys0y76Za+J4b5IpiNS93YbpBxS7iDNRC/TpXmKAA==')
  end
end
