# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/chain_info'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::ChainInfo do
  describe 'when deserialization is successful' do
    let(:chain_info_data) do
      {
        'net_name' => 'debugnet',
        'protocol_version' => '1.0',
        'head_block' => '16041',
        'head_block_hash' => 'DLJVtko6nQnAdvQ7y6dXHo3WMdG324yRLz8tPKk9tGHu',
        'lib_block' => '16028',
        'lib_block_hash' => '8apn7vCvQ6s9PFBzGfaXrvyL5eAaLNc4mEAgnTMoW8tC',
        'witness_list' => [
          'IOST2K9GKzVazBRLPTkZSCMcyMayKv7dWgdHD8uuWPzjfPdzj93x6J',
          'IOST2YKPmRDGy5xLR7Gv65CN5nQ3vMmVhRjAsEM7Gj9xcB1LWgZUAd',
          'IOST7E4T5rG9wjPZXDeM1zjhhWU3ZswtPQ1heeRUFUxntr65sYRBi'
        ]
      }
    end

    it 'should return a valid ChainInfo instance' do
      chain_info = IOSTSdk::Models::ChainInfo.new.populate(model_data: chain_info_data)
      expect(chain_info).not_to be_nil
      expect(chain_info.net_name).to eq(chain_info_data['net_name'])
      expect(chain_info.protocol_version).to eq(chain_info_data['protocol_version'])
      expect(chain_info.head_block).to eq(chain_info_data['head_block'])
      expect(chain_info.head_block_hash).to eq(chain_info_data['head_block_hash'])
      expect(chain_info.lib_block).to eq(chain_info_data['lib_block'])
      expect(chain_info.lib_block_hash).to eq(chain_info_data['lib_block_hash'])
      expect(chain_info.witness_list).to eq(chain_info_data['witness_list'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::ChainInfo.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
