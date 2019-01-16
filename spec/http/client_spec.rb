# frozen_string_literal: true

require 'iost_sdk/http/client'

RSpec.describe IOSTSdk::Http::Client do
  describe 'all API call methods' do
    let(:base_url) { 'http://47.244.109.92:30001' }
    let(:client) { IOSTSdk::Http::Client.new(base_url: base_url) }

    it '/getNodeInfo should succeed' do
      node_info = client.get_node_info
      expect(node_info).not_to be_nil
      expect(node_info.is_a?(IOSTSdk::Models::NodeInfo)).to be_truthy
    end

    it '/getChainInfo should succeed' do
      chain_info = client.get_chain_info
      expect(chain_info).not_to be_nil
      expect(chain_info.is_a?(IOSTSdk::Models::ChainInfo)).to be_truthy
    end

    it '/getGasRatio should succeed' do
      gas_ratio = client.get_gas_ratio
      expect(gas_ratio).not_to be_nil
      expect(gas_ratio.is_a?(IOSTSdk::Models::GasRatio)).to be_truthy
    end
  end
end
