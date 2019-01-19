# frozen_string_literal: true

require 'iost_sdk/crypto'

RSpec.describe IOSTSdk::Crypto do
  it 'should raise an exception if algo is unsupported' do
    expect { IOSTSdk::Crypto.new_keypair(algo: 'haha') }.to raise_error(ArgumentError)
    expect { IOSTSdk::Crypto.keypair_from_private_key(algo: 'haha', encoded_private_key: 'abcd') }.to raise_error(ArgumentError)
  end

  describe 'Secp256k1' do
    before(:all) do
      @test_data = {}
    end

    it 'should create a new key pair successfully' do
      key_pair = IOSTSdk::Crypto.new_keypair(algo: 'secp256k1')
      expect(key_pair).not_to be_nil
      expect(key_pair.is_a?(IOSTSdk::Crypto::KeyPair)).to be_truthy
      expect(key_pair.id).to eq(key_pair.public_key)
      @test_data[:private_key] = key_pair.private_key
      @test_data[:public_key] = key_pair.public_key
    end

    it 'should create a new key pair from an existing private key successfully' do
      key_pair = IOSTSdk::Crypto.keypair_from_private_key(
        algo: 'secp256k1',
        encoded_private_key: @test_data[:private_key]
      )
      expect(key_pair).not_to be_nil
      expect(key_pair.is_a?(IOSTSdk::Crypto::KeyPair)).to be_truthy
      expect(key_pair.id).to eq(key_pair.public_key)
      expect(key_pair.public_key).to eq(@test_data[:public_key])
    end
  end

  describe 'Ed25519' do
    before(:all) do
      @test_data = {}
    end

    it 'should create a new key pair successfully' do
      key_pair = IOSTSdk::Crypto.new_keypair(algo: 'Ed25519')
      expect(key_pair).not_to be_nil
      expect(key_pair.is_a?(IOSTSdk::Crypto::KeyPair)).to be_truthy
      expect(key_pair.id).to eq(key_pair.public_key)
      @test_data[:private_key] = key_pair.private_key
      @test_data[:public_key] = key_pair.public_key
    end

    it 'should create a new key pair from an existing private key successfully' do
      key_pair = IOSTSdk::Crypto.keypair_from_private_key(
        algo: 'Ed25519',
        encoded_private_key: @test_data[:private_key]
      )
      expect(key_pair).not_to be_nil
      expect(key_pair.is_a?(IOSTSdk::Crypto::KeyPair)).to be_truthy
      expect(key_pair.id).to eq(key_pair.public_key)
      expect(key_pair.public_key).to eq(@test_data[:public_key])
    end

    it 'should create a new KeyPair from an existing keypair string' do
      key_pair = IOSTSdk::Crypto.from_keypair(encoded_keypair: 'r25LPh94Dw485p1oS1VMPBH6vXkgosxrEmmy3sCSmAUzrJJSMbxE8QpxPEARRJptkeLJQtAxWDDF8Uqo4NRDeqN')
      expect(key_pair.is_a?(IOSTSdk::Crypto::KeyPair)).to be_truthy
      expect(key_pair.id).to eq(key_pair.public_key)
      expect(key_pair.public_key).to eq('DkYmjgWxW6e7y5pCbGNYkw5xCwRHdHdb2mMg37ZGCRSx')
    end
  end
end
