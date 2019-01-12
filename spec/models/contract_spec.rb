# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/contract'
require 'iost_sdk/errors'

RSpec.describe IOSTSdk::Models::Contract do
  describe 'when deserialization is successful' do
    let(:contract_data) do
      {
        'id' => 'base.iost',
        'code' => "const producerPermission = 'active';\nconst voteStatInterval = 200;\nclass Base {\n    constructor() {\n    }\n    init() {\n        _IOSTInstruction_counter.incr(12);this._put('execBlockNumber', 0);\n    }\n    InitAdmin(adminID) {\n        _IOSTInstruction_counter.incr(4);const bn = block.number;\n        if (_IOSTInstruction_counter.incr(8),_IOSTBinaryOp(bn, 0, '!==')) {\n            _IOSTInstruction_counter.incr(14);throw new Error('init out of genesis block');\n        }\n        _IOSTInstruction_counter.incr(12);this._put('adminID', adminID);\n    }\n    can_update(data) {\n        _IOSTInstruction_counter.incr(12);const admin = this._get('adminID');\n        _IOSTInstruction_counter.incr(12);this._requireAuth(admin, producerPermission);\n        return true;\n    }\n    _requireAuth(account, permission) {\n        _IOSTInstruction_counter.incr(12);const ret = BlockChain.requireAuth(account, permission);\n        if (_IOSTInstruction_counter.incr(8),_IOSTBinaryOp(ret, true, '!==')) {\n            _IOSTInstruction_counter.incr(22);throw new Error(_IOSTBinaryOp('require auth failed. ret = ', ret, '+'));\n        }\n    }\n    _get(k) {\n        _IOSTInstruction_counter.incr(12);const val = storage.get(k);\n        if (_IOSTInstruction_counter.incr(8),_IOSTBinaryOp(val, '', '===')) {\n            return null;\n        }\n        _IOSTInstruction_counter.incr(12);return JSON.parse(val);\n    }\n    _put(k, v) {\n        _IOSTInstruction_counter.incr(24);storage.put(k, JSON.stringify(v));\n    }\n    _vote() {\n        _IOSTInstruction_counter.incr(12);BlockChain.callWithAuth('vote_producer.iost', 'Stat', `[]`);\n    }\n    _bonus(data) {\n        _IOSTInstruction_counter.incr(24);BlockChain.callWithAuth('bonus.iost', 'IssueContribute', JSON.stringify([data]));\n    }\n    _saveBlockInfo() {\n        _IOSTInstruction_counter.incr(12);let json = storage.get('current_block_info');\n        _IOSTInstruction_counter.incr(36);storage.put(_IOSTBinaryOp('chain_info_', block.parentHash, '+'), JSON.stringify(json));\n        _IOSTInstruction_counter.incr(24);storage.put('current_block_info', JSON.stringify(block));\n    }\n    Exec(data) {\n        _IOSTInstruction_counter.incr(12);this._saveBlockInfo();\n        _IOSTInstruction_counter.incr(4);const bn = block.number;\n        _IOSTInstruction_counter.incr(12);const execBlockNumber = this._get('execBlockNumber');\n        if (_IOSTInstruction_counter.incr(8),_IOSTBinaryOp(bn, execBlockNumber, '===')) {\n            return true;\n        }\n        _IOSTInstruction_counter.incr(12);this._put('execBlockNumber', bn);\n        if (_IOSTInstruction_counter.incr(16),_IOSTBinaryOp(_IOSTBinaryOp(bn, voteStatInterval, '%'), 0, '===')) {\n            _IOSTInstruction_counter.incr(12);this._vote();\n        }\n        _IOSTInstruction_counter.incr(12);this._bonus(data);\n    }\n}\n_IOSTInstruction_counter.incr(7);module.exports = Base;",
        'language' => 'javascript',
        'version' => '1.0.0',
        'abis' => [{
          'name' => 'Exec',
          'args' => ['json'],
          'amount_limit' => []
        }, {
          'name' => 'can_update',
          'args' => ['string'],
          'amount_limit' => []
        }, {
          'name' => 'InitAdmin',
          'args' => ['string'],
          'amount_limit' => []
        }, {
          'name' => 'init',
          'args' => [],
          'amount_limit' => []
        }]
      }
    end

    it 'should return a valid Contract instance' do
      contract = IOSTSdk::Models::Contract.new.populate(model_data: contract_data)
      expect(contract).not_to be_nil
      expect(contract.id).to eq(contract_data['id'])
      expect(contract.code).to eq(contract_data['code'])
      expect(contract.language).to eq(contract_data['language'])
      expect(contract.version).to eq(contract_data['version'])
      # ABI
      expect(contract.abis.is_a?(Array)).to be_truthy
      expect(contract.abis.size).to eq(4)
      4.times do |n|
        expect(contract.abis[n].name).to eq(contract_data['abis'][n]['name'])
        expect(contract.abis[n].args).to eq(contract_data['abis'][n]['args'])
        expect(contract.abis[n].amount_limit).to eq(contract_data['abis'][n]['amount_limit'])
      end
    end
  end

  describe 'when deserialization is unsuccessful' do
    it 'should raise an InvalidModelDataError' do
      expect {
        IOSTSdk::Models::Contract.new.populate(model_data: { 'name' => 'IOST' })
      }.to raise_error(IOSTSdk::Errors::InvalidModelDataError)
    end
  end
end
