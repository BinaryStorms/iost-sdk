# iost-sdk
Ruby SDK for IOST Blockchain

[![Build Status](https://travis-ci.org/BinaryStorms/iost-sdk.svg?branch=master)](https://travis-ci.org/BinaryStorms/iost-sdk)
[![Coverage Status](https://coveralls.io/repos/github/BinaryStorms/iost-sdk/badge.svg?branch=feature_models_for_response)](https://coveralls.io/github/BinaryStorms/iost-sdk?branch=master)

## Overview

This is a Ruby SDK for interacting with the [IOST blockchain](https://iost.io/). It makes HTTP requests to the JSON RPC endpoints
on the IOST nodes.

## Usage

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
           .send(account_name: 'admin', key_pair: key_pair)
# transfer tokens
resp = iost.transfer(
             token: 'iost',
             from: 'rich',
             to: 'poor',
             amount: '10.000',
             memo: 'free tokens!'
           )
           .send(account_name: 'rich', key_pair: key_pair)
# call ABI
resp = iost.call_abi(
             contract_id: 'token.iost',
             abi_name: 'transfer',
             abi_args: ['iost', 'rich', 'poor', '10.000', 'hey hey']
           )
           .send(account_name: 'rich', key_pair: key_pair)
```
