# frozen_string_literal: true

module IOSTSdk
  module Crypto
    require 'btcruby'
    require 'ed25519'
    require 'base58'
    require 'sha3'

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
                                  p_key = BTC::Key.random
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
                                  p_key = BTC::Key.new(
                                    private_key: Base58.base58_to_binary(encoded_private_key, :bitcoin)
                                  )
                                  [p_key.public_key, p_key.private_key]
                                elsif algo == KEY_ALGOS[:Ed25519]
                                  private_key = Ed25519::SigningKey.new(
                                    Base58.base58_to_binary(encoded_private_key, :bitcoin)
                                  )
                                  public_key = private_key.verify_key

                                  [public_key, private_key]
                                end

      KeyPair.new(algo: algo, public_key: public_key, private_key: private_key)
    end

    # Create an instance of KeyPair from an +Ed25519+ keypair string
    #
    # @param encoded_kaypair [String] a Base58 encoded Ed25519 keypair string
    # @return an instance of KeyPair
    def self.from_keypair(encoded_keypair:)
      private_key = Ed25519::SigningKey.from_keypair(
        Base58.base58_to_binary(encoded_keypair, :bitcoin)
      )

      KeyPair.new(
        algo: IOSTSdk::Crypto::KEY_ALGOS[:Ed25519],
        public_key: private_key.verify_key,
        private_key: private_key
      )
    end

    class KeyPair
      attr_reader :algo

      # Create an instance of KeyPair
      #
      # @param algo [String] the algorithm used to generate the key pair
      # @param public_key [Ed25519::VerifyKey|OpenSSL::PKey::EC::Point] an instance of the public key
      # @param private_key [Ed25519::SigningKey|OpenSSL::BN] an instance of the private key
      # @return an instance of KeyPair
      def initialize(algo:, public_key:, private_key:)
        @algo = algo
        @public_key = public_key
        @private_key = private_key
      end

      def public_key
        Base58.binary_to_base58(public_key_raw, :bitcoin)
      end

      def public_key_raw
        if @algo == IOSTSdk::Crypto.key_algos[:Secp256k1]
          # @public_key is in bytes already
          @public_key
        elsif @algo == IOSTSdk::Crypto.key_algos[:Ed25519]
          @public_key.to_bytes
        end
      end

      def private_key
        Base58.binary_to_base58(private_key_raw, :bitcoin)
      end

      def private_key_raw
        if @algo == IOSTSdk::Crypto.key_algos[:Secp256k1]
          # @private_key is in bytes already
          @private_key
        elsif @algo == IOSTSdk::Crypto.key_algos[:Ed25519]
          @private_key.to_bytes
        end
      end

      def id
        public_key
      end

      def sign(message:)
        if @algo == IOSTSdk::Crypto.key_algos[:Secp256k1]
          p_key = BTC::Key.new(private_key: @private_key)
          der_signature = p_key.ecdsa_signature(message)
          decoded_der = OpenSSL::ASN1.decode(der_signature)
          decoded_der.value
                     .map { |v| v.value.to_s(2) }
                     .flatten
                     .join
        elsif @algo == IOSTSdk::Crypto.key_algos[:Ed25519]
          @private_key.sign(message)
        end
      end
    end
  end
end
