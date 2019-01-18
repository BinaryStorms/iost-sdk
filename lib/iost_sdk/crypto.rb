# frozen_string_literal: true

module IOSTSdk
  module Crypto
    require 'openssl'
    require 'ed25519'
    require 'base58'

    KEY_ALGOS = {
      Secp256k1: 'secp256k1',
      Ed25519: 'Ed25519'
    }.freeze

    def self.key_algos
      KEY_ALGOS
    end

    # Create an instance of KeyPair by generating a brand new pair of public-private keys
    #
    # @param algo [String] the algorithm should be used to generate the new key pair
    # @return an instance of +KeyPair+
    def self.new_keypair(algo:)
      raise ArgumentError.new("Invalid keypair algo: #{algo}") unless Set.new(KEY_ALGOS.values).include?(algo)

      public_key, private_key = if algo == KEY_ALGOS[:Secp256k1]
                                  p_key = OpenSSL::PKey::EC.new(algo).generate_key
                                  [p_key.public_key, p_key.private_key]
                                elsif algo == KEY_ALGOS[:Ed25519]
                                  private_key = Ed25519::SigningKey.generate
                                  public_key = private_key.verify_key

                                  [public_key, private_key]
                                end
      KeyPair.new(algo: algo, public_key: public_key, private_key: private_key)
    end

    # Create an instance of KeyPair from a +private_key_hex+ in a given +algo+
    #
    # @param algo [String] the algorithm used to generate the key pair
    # @param encoded_private_key [String] the Base58 encoded string of an existing private key
    # @return an instance of +KeyPair+
    def self.keypair_from_private_key(algo:, encoded_private_key:)
      raise ArgumentError.new("Invalid algo: #{algo}") unless Set.new(KEY_ALGOS.values).include?(algo)

      public_key, private_key = if algo == KEY_ALGOS[:Secp256k1]
                                  p_key = OpenSSL::PKey::EC.new(algo)
                                  private_key = OpenSSL::BN.new(
                                    Base58.decode(encoded_private_key)
                                  )
                                  public_key = p_key.group.generator.mul(private_key)

                                  [public_key, private_key]
                                elsif algo == KEY_ALGOS[:Ed25519]
                                  private_key = Ed25519::SigningKey.new(Base58.base58_to_binary(encoded_private_key))
                                  public_key = private_key.verify_key

                                  [public_key, private_key]
                                end

      KeyPair.new(algo: algo, public_key: public_key, private_key: private_key)
    end

    class KeyPair
      # Create an instance of KeyPair
      #
      # @param algo [String] the algorithm used to generate the key pair
      # @param public_key [String] the HEX value of the public key
      # @param private_key [String] the HEX value of the private key
      # @return an instance of KeyPair
      def initialize(algo:, public_key:, private_key:)
        @algo = algo
        @public_key = public_key
        @private_key = private_key
      end

      def public_key
        if @algo == IOSTSdk::Crypto.key_algos[:Secp256k1]
          # @public_key is an instance of OpenSSL::PKey::EC::Point
          hex_str = @public_key.to_bn.to_s
          # convert to base58 encoding
          Base58.encode(hex_str.to_i(10))
        elsif @algo == IOSTSdk::Crypto.key_algos[:Ed25519]
          Base58.binary_to_base58(@public_key.to_bytes)
        end
      end

      def private_key
        if @algo == IOSTSdk::Crypto.key_algos[:Secp256k1]
          # @private_key is an instance of OpenSSL::BN
          str = @private_key.to_s
          # convert to base58 encoding
          Base58.encode(str.to_i(10))
        elsif @algo == IOSTSdk::Crypto.key_algos[:Ed25519]
          Base58.binary_to_base58(@private_key.to_bytes)
        end
      end

      def id
        public_key
      end
    end
  end
end
