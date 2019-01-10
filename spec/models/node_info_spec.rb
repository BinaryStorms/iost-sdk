# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/node_info'
require 'iost_sdk/errors'

RSpec.describe IostSdk::Models::NodeInfo do
  describe 'when deserialization is successful' do
    let(:node_info_data) do
      {
        'build_time' => '20181208_161822+0800',
        'git_hash' => '1f540ec5b619812cb01b7bbc3dd89dbd3849c6fb',
        'mode' => 'ModeNormal',
        'network' => {
          'id' => '12D3KooWGGauAVW7vQw33kAAttbyTVf81Urpi2f4LYBAXTYzhwqj',
          'peer_count' => 1,
          'peer_info' => [
            {
              'id' => '12D3KooWPSPLPyDFtcbKUvQGWM7pCXWEhRAjA1A5nAAFEvnce1Dm',
              'addr' => '/ip4/127.0.0.1/tcp/50004'
            }
          ]
        }
      }
    end

    it 'should return a valid NodeInfo instance' do
      node_info = IostSdk::Models::NodeInfo.new.populate(model_data: node_info_data)
      expect(node_info).not_to be_nil
      expect(node_info.build_time).to eq(node_info_data['build_time'])
      expect(node_info.git_hash).to eq(node_info_data['git_hash'])
      expect(node_info.mode).to eq(node_info_data['mode'])
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IostSdk::Models::NodeInfo.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IostSdk::Errors::InvalidModelDataError)
    end
  end
end
