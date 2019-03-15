# iost-sdk
Ruby SDK for IOST Blockchain

[![Build Status](https://travis-ci.org/BinaryStorms/iost-sdk.svg?branch=master)](https://travis-ci.org/BinaryStorms/iost-sdk)
[![Coverage Status](https://coveralls.io/repos/github/BinaryStorms/iost-sdk/badge.svg?branch=feature_models_for_response)](https://coveralls.io/github/BinaryStorms/iost-sdk?branch=master)

## Overview

This is a Ruby SDK for interacting with the [IOST blockchain](https://iost.io/). It makes HTTP requests to the JSON RPC endpoints on the IOST nodes.

## Usage

### Retrieve information from IOST

These method calls, arguments, and return object should match the [official IOST API](https://developers.iost.io/docs/en/6-reference/API.html)

```ruby
require 'iost_sdk'

# set the JSON RPC endpoint base URL
base_url = 'https://127.0.0.1:30001'
iost = IOSTSdk::Main.new(endpoint: base_url)

# get node info
node_info = iost.get_node_info

# get chain info
chain_info = iost.get_chain_info

# get gas ratio
gas_ratio = iost.get_gas_ratio

# get ram info
ram_info = iost.get_ram_info

# get transaction by hash
txn = iost.get_tx_by_hash(hash_value: 'my-transaction-hash')

# get transaction receipt by hash
tx_receipt = iost.get_tx_receipt_by_tx_hash(hash_value: 'my-transaction-receipt-hash')

# get block by hash
block_info = iost.get_block_by_hash(hash_value: 'hash-value', complete: true)

# get block by number
block_info = iost.get_block_by_number(number: 123, complete: true)

# get account
account = iost.get_account(name: 'my_account', by_longest_chain: true)

# get token balance
token_balance = iost.get_token_balance(
  account_name: 'my_account',
  token_name: 'iost',
  by_longest_chain: true
)

# get contract
contract = iost.get_contract(id: 'contract_123', by_longest_chain: true)

# get contract storage
query = IOSTSdk::Models::Query::ContractStorage.new.populate(
  model_data: {
    'id' => 'contract_id',
    'field' => 'producer002',
    'key' => 'producerTable',
    'by_longest_chain' => true
  }
)
contract_storage = iost.get_contract_storage(query: query)

# get contract storage fields
query = IOSTSdk::Models::Query::ContractStorageFields.new.populate(
  model_data: {
    'id' => @test_data[:contract_name],
    'key' => 'producerTable',
    'by_longest_chain' => true
  }
)
contract_storage_fields = iost.get_contract_storage_fields(query: query)
```

### Create, sign and send transactions

The method `sign_and_send` returns AFTER the transaction has become irreversible. It has a
maximum timeout of 90 seconds.

```ruby
require 'iost_sdk'

# set the JSON RPC endpoint base URL
base_url = 'https://127.0.0.1:30001'
iost = IOSTSdk::Main.new(endpoint: base_url)
# create a new account
resp = iost.new_account(
             name: 'n00b',
             creator: 'admin',
             owner_key: key_pair,
             active_key: key_pair,
             initial_ram: 10,
             initial_gas_pledge: 0
           )
           .sign_and_send(account_name: 'admin', key_pair: key_pair)
# transfer tokens
resp = iost.transfer(
             token: 'iost',
             from: 'rich',
             to: 'poor',
             amount: '10.000',
             memo: 'free tokens!'
           )
           .sign_and_send(account_name: 'rich', key_pair: key_pair)
# call ABI
resp = iost.call_abi(
             contract_id: 'token.iost',
             abi_name: 'transfer',
             abi_args: ['iost', 'rich', 'poor', '10.000', 'hey hey']
           )
           .sign_and_send(account_name: 'rich', key_pair: key_pair)

# resp is a hash with keys :status and :txn_hash
status = resp[:status] # status can be `pending`, `success` or `failed`
txn_hash = resp[:txn_hash]
```
