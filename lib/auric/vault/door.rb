require "auric/vault/door/version"
require 'openssl'
require 'HTTParty'

module Auric
  module Vault
    class Door
      attr_accessor :secret, :mtid, :config_id, :production, :segment
      attr_reader :error, :success
      SANDBOXURLS = ['https://vault01-sb.auricsystems.com/vault/v2/', 'https://vault02-sb.auricsystems.com/vault/v2/']
      PRODUCTIONURLS= ['https://vault01-sb.auricsystems.com/vault/v2/', 'https://vault02-sb.auricsystems.com/vault/v2/']

      def initialize(secret, mtid, config_id, segment, production = false)
        @secret = secret
        @mtid = mtid
        @config_id = config_id
        @production = production
        @segment = segment
        @success = false
        @error = nil
        if @production
          @url = PRODUCTIONURLS.first
        else
          @url = SANDBOXURLS.first
        end
      end

      def encrypt(data)
        json = post_data('encrypt', data)
        if @success
          return json['result']['token']
        else
          @error = json['error']
          return false
        end
      end

      def decrypt(token)
        json = get_data('decrypt', token)
        if @success
          return json['result']['plaintextValue']
        else
          @error = json['error']
          return false
        end
      end

      private

      def build_post_message(method, plaintext_value)
        {
          'params'=>
          [{
            'mtid'=> @mtid,
            'configurationId'=> @config_id,
            'utcTimestamp'=> Time.now.to_i.to_s,
            'retention'=> 'big-year',
            'segment'=> @segment,
            'last4'=> '',
            'plaintextValue'=> plaintext_value
          }],
          'method'=> method
        }
      end

      def build_get_message(method, token)
        {
          'params'=>
          [{
            'mtid'=> @mtid,
            'configurationId'=> @config_id,
            'utcTimestamp'=> Time.now.to_i.to_s,
            'token'=> token
          }],
          'method'=> method
        }
      end

      def figure_hexdigest_for_auth(message_body)
        digest = OpenSSL::Digest.new('sha512')
        OpenSSL::HMAC.hexdigest(digest, @secret, message_body.to_json)
      end

      def call_auric(method, data)
        signature = figure_hexdigest_for_auth(data)
        HTTParty.post(
          @url,
          {
            :body => data.to_json,
            headers: { 'X-VAULT-HMAC' => signature }
          }
        )
      end

      def post_data(method, data)
        message_body = build_post_message(method, data)
        response = call_auric(method, message_body)
        json_response = JSON.parse(response.parsed_response)
        if json_response['result']['lastActionSucceeded'] == 1
          @success = true
        else
          @success = false
        end
        json_response
      end

      def get_data(method, data)
        message_body = build_get_message(method, data)
        response = call_auric(method, message_body)
        json_response = JSON.parse(response.parsed_response)
        if json_response['result']['lastActionSucceeded'] == 1
          @success = true
        else
          @success = false
        end
        json_response
      end
    end
  end
end
