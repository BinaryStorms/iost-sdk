# frozen_string_literal: true

require 'iost_sdk/models/query/transaction'

RSpec.describe IOSTSdk::Models::Query::Transaction do
  let(:now) { Time.now.utc.to_i }
  let(:txn) {
    IOSTSdk::Models::Query::Transaction.new.populate(
      model_data: {
        'time' => now * 1_000_000,
        'expiration' => now + 30 * 1_000_000,
        'gas_ratio' => 10,
        'gas_limit' => 100,
        'delay' => 30,
        'chain_id' => 0,
        'signers' => [],
        'actions' => [],
        'amount_limit' => [],
        'signatures' => []
      }
    )
  }

  describe '.add_approve' do
    it 'should not raise an error if token is *' do
      expect { txn.add_approve(token: '*', amount: 89.0) }.not_to raise_error
    end

    it 'should raise an error if amount is not numeric' do
      expect { txn.add_approve(token: 'iost', amount: '89.0') }.to raise_error(IOSTSdk::Errors::InvalidTransactionError)
      expect { txn.add_approve(token: 'iost', amount: true) }.to raise_error(IOSTSdk::Errors::InvalidTransactionError)
      expect { txn.add_approve(token: 'iost', amount: [89, 0]) }.to raise_error(IOSTSdk::Errors::InvalidTransactionError)
    end
  end

  describe '.is_valid?' do
    it 'should return false if gas limit is not numeric' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => 10,
          'gas_limit' => 'hello',
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end

    it 'should return false if gas limit is out of range' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => 10,
          'gas_limit' => 9,
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end

    it 'should return false if gas ratio is not numeric' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => '10',
          'gas_limit' => 60,
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end

    it 'should return false if gas ratio is out of range' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => 0,
          'gas_limit' => 60,
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end

    it 'should return false if approve token is *' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => 5,
          'gas_limit' => 60,
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [
            {
              'token' => '*',
              'value' => '45.09'
            }
          ],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end

    it 'should return false if approve amount is not numeric' do
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => now * 1_000_000,
          'expiration' => now + 30 * 1_000_000,
          'gas_ratio' => 5,
          'gas_limit' => 60,
          'delay' => 30,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [
            {
              'token' => 'iost',
              'value' => 'hello'
            }
          ],
          'signatures' => []
        }
      )
      expect(transaction.is_valid?).to eq(false)
    end
  end
end
