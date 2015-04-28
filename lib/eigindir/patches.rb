# encoding: utf-8

module Eigindir

  # @api private
  module Patches

    refine Hash do

      # Returns a new hash whose keys are symbolized
      #
      # @example
      #   { "foo" => "foo", "bar" => { "baz" => "baz" } }.normalize
      #   # => { foo: "foo", bar: { "baz" => "baz" } }
      #
      # @return [Hash]
      def normalize
        keys.map(&:to_sym).zip(values).to_h
      end

      # Returns a new hash with given keys only
      #
      # @example
      #   { foo: "foo", bar: "bar" }.slice(:foo, :baz)
      #   # => { foo: "foo" }
      #
      # @param [Array] list The keys to slice from the hash
      #
      # @return [Hash]
      def slice(*list)
        sliced_keys = keys & list
        sliced_keys.zip(values_at(*sliced_keys)).to_h
      end

    end # refine Hash

  end # module Patches

end # module Eigindir
