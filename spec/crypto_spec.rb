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

    describe 'key pair generation from scratch' do
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

    describe 'key pair generation from existing private key' do
      let(:private_key) { 'EhNiaU4DzUmjCrvynV3gaUeuj2VjB1v2DCmbGD5U2nSE' }
      let(:key_pair) do
        IOSTSdk::Crypto.keypair_from_private_key(
          algo: IOSTSdk::Crypto.key_algos[:Secp256k1],
          encoded_private_key: private_key
        )
      end
      let(:sha3_digest) { SHA3::Digest.new(:sha256) }

      it 'should create the correct private key' do
        expect(Base58.base58_to_binary(key_pair.private_key, :bitcoin).unpack('H*').first)
          .to eq('cb7fb7bc876557cbcbe86b81db9d4b229382d440cd493ae1216ecc557ce0a4e3')
      end

      it 'should derive the correct public key' do
        expect(Base58.base58_to_binary(key_pair.public_key, :bitcoin).unpack('H*').first)
          .to eq('02069b1abdaaf8326e7e6fc15607fd9e6c6f595e119a2484a4192b5d6b3878dd25')
      end

      it 'should generate the correct id' do
        expect(key_pair.id).to eq('buRN2pBJfoR3rMt3yt4a2HU5Q2Qc2oJMJF71zzwAEz1A')
      end
    end

    describe 'message signing' do
      let(:sha3_digest) { SHA3::Digest.new(:sha256) }
      let(:private_key) { 'EhNiaU4DzUmjCrvynV3gaUeuj2VjB1v2DCmbGD5U2nSE' }
      let(:message) { 'hello' }
      let(:key_pair) do
        IOSTSdk::Crypto.keypair_from_private_key(
          algo: IOSTSdk::Crypto.key_algos[:Secp256k1],
          encoded_private_key: private_key
        )
      end

      it 'should generate the correct public key' do
        expect([Base58.base58_to_binary(key_pair.public_key, :bitcoin)].pack('m0'))
          .to eq('AgabGr2q+DJufm/BVgf9nmxvWV4RmiSEpBkrXWs4eN0l')
      end

      it 'should generate the correct signature' do
        signature = key_pair.sign(message: message)
        existing_signature = 'N/dzG9uZiKozC+i71qeR8R2f6QYB7ff1afa43c/dd1UzOymco6hDfnHrFMcqAqLFzfNWLokfWjwdVNkhSCNuEA=='
        expect([signature].pack('m0')).to eq(existing_signature)
      end
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
