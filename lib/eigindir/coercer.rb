# encoding: utf-8

module Eigindir

  # Class Coercer creates the proc to be called by attribute getter and setter
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  # @api private
  class Coercer

    # Checks the coercer validity and creates its istance
    #
    # @option [Proc, Symbol, String, NilClass] :coerce
    # @option [Boolean] :strict
    #
    # @return [Eigindir::Coercer]
    def self.new(coerce: nil, strict: nil)
      super if coerce
    end

    # @private
    def initialize(coerce: nil, strict: nil)
      @coerce = coerce
      @strict = strict
      check_type
      check_arity
    end

    # Coerces a value in a context of some instance
    #
    # @param [Object] instance
    #   The object whose method is used to coerce value
    # @param [Object] value
    #   The value to coerce
    #
    # @return [Object] the coerced value
    def call(instance, value)
      proc.call(instance, value) if value || strict
    end

    private

    attr_reader :coerce, :strict, :proc

    def proc
      coerce.instance_of?(Proc) ? proc_coercer : method_coercer
    end

    def method_coercer
      ->(instance, value) { instance.__send__ coerce, value }
    end

    def proc_coercer
      ->(_, value) { coerce.call value }
    end

    def check_type
      return if [Proc, String, Symbol].include? coerce.class
      fail TypeError.new "#{ coerce } is not a Proc, Symbol, or String"
    end

    def check_arity
      return unless coerce.instance_of?(Proc) && coerce.arity != 1
      fail ArgumentError.new "Coercer should take exactly one argument"
    end

  end # class Coercer

end # module Eigindir
