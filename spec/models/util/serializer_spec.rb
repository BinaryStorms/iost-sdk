# frozen_string_literal: true

require 'iost_sdk/models/util/serializer'

RSpec.describe IOSTSdk::Models::Util::Serializer do
  let(:serializer) { IOSTSdk::Models::Util::Serializer }

  it 'should serialize int64 correctly' do
    expect(serializer.int64_to_bytes(1023)).to eq([0, 0, 0, 0, 0, 0, 3, 255])
  end

  it 'should serialize string correctly' do
    expect(serializer.string_to_bytes('iost')).to eq(
      [0, 0, 0, 4, 105, 111, 115, 116]
    )
  end

  it 'should serialize array correctly' do
    expect(serializer.array_to_bytes(['iost', 'iost'])).to eq(
      [0, 0, 0, 2, 0, 0, 0, 4, 105, 111, 115, 116, 0, 0, 0, 4, 105, 111, 115, 116]
    )
  end

  it 'should serialize hash correctly' do
    expect(serializer.hash_to_bytes(a: 'iost', b: 'iost')).to eq(
      [0, 0, 0, 2, 0, 0, 0, 1, 97, 0, 0, 0, 4, 105, 111, 115, 116, 0, 0, 0, 1, 98, 0, 0, 0, 4, 105, 111, 115, 116] 
    )
  end
end
