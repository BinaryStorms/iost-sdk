# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/account'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::Account do
  describe 'when deserialization is successful' do
    let(:account_data) do
      {
        "name" => "producer001",
        "balance" => 0,
        "gas_info" => {
          "current_total" => 30000000,
          "transferable_gas" => 0,
          "pledge_gas" => 30000000,
          "increase_speed" => 115,
          "limit" => 30000000,
          "pledged_info" => []
        },
        "ram_info" => {
          "available" => "100000",
          "used" => "0",
          "total" => "100000"
        },
        "permissions" => {
          "active" => {
            "name" => "active",
            "group_names" => [],
            "items" => [
              {
                "id" => "AcUVEg2RmxtFsybwGgnFZdByoY86MU6M8fZgk8L2pc7F",
                "is_key_pair" => true,
                "weight" => "100",
                "permission" => ""
              }
            ],
            "threshold" => "100"
          },
          "owner" => {
            "name" => "owner",
            "group_names" => [],
            "items" => [
              {
                "id" => "AcUVEg2RmxtFsybwGgnFZdByoY86MU6M8fZgk8L2pc7F",
                "is_key_pair" => true,
                "weight" => "100",
                "permission" => ""
              }
            ],
            "threshold" => "100"
          }
        },
        "groups" => {},
        "frozen_balances" => [],
        "vote_infos" => []
      }
    end

    it 'should return a valid Account instance' do
      account = IOSTSdk::Models::Account.new.populate(model_data: account_data)
      expect(account).not_to be_nil
      expect(account.name).to eq(account_data['name'])
      expect(account.balance).to eq(account_data['balance'])
      # GasInfo
      expect(account.gas_info.is_a?(IOSTSdk::Models::GasInfo)).to be_truthy
      expect(account.gas_info.current_total).to eq(account_data['gas_info']['current_total'])
      expect(account.gas_info.transferable_gas).to eq(account_data['gas_info']['transferable_gas'])
      expect(account.gas_info.pledge_gas).to eq(account_data['gas_info']['pledge_gas'])
      expect(account.gas_info.increase_speed).to eq(account_data['gas_info']['increase_speed'])
      expect(account.gas_info.limit).to eq(account_data['gas_info']['limit'])
      # PledgeInfo
      expect(account.gas_info.pledged_info.is_a?(Array)).to be_truthy
      expect(account.gas_info.pledged_info.size).to eq(0)
      # AccountRAMInfo
      expect(account.ram_info.is_a?(IOSTSdk::Models::AccountRAMInfo)).to be_truthy
      expect(account.ram_info.available).to eq(account_data['ram_info']['available'])
      expect(account.ram_info.used).to eq(account_data['ram_info']['used'])
      expect(account.ram_info.total).to eq(account_data['ram_info']['total'])
      # Permission
      expect(account.permissions.is_a?(Hash)).to be_truthy
      # active permission
      expect(account.permissions['active'].is_a?(IOSTSdk::Models::Permission)).to be_truthy
      expect(account.permissions['active'].name).to eq(account_data['permissions']['active']['name'])
      expect(account.permissions['active'].group_names).to eq(account_data['permissions']['active']['group_names'])
      expect(account.permissions['active'].threshold).to eq(account_data['permissions']['active']['threshold'])
      # permission item
      expect(account.permissions['active'].items.is_a?(Array)).to be_truthy
      expect(account.permissions['active'].items.size).to eq(1)
      expect(account.permissions['active'].items.first.is_a?(IOSTSdk::Models::PermissionItem)).to be_truthy
      expect(account.permissions['active'].items.first.id).to eq(account_data['permissions']['active']['items'].first['id'])
      expect(account.permissions['active'].items.first.is_key_pair).to eq(account_data['permissions']['active']['items'].first['is_key_pair'])
      expect(account.permissions['active'].items.first.weight).to eq(account_data['permissions']['active']['items'].first['weight'])
      expect(account.permissions['active'].items.first.permission).to eq(account_data['permissions']['active']['items'].first['permission'])
      # PermissionGroup
      expect(account.groups.empty?).to be_truthy
      # FrozenBalance
      expect(account.frozen_balances.empty?).to be_truthy
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::Account.new.populate(model_data: { 'jedi' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
