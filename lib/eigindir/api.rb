# encoding: utf-8

module Eigindir

  # The module provides class-level API
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  module API

    # Declares the attribute
    #
    # @param  (see #attribute_reader)
    # @option (see #attribute_reader)
    # @option [Proc, Symbol, String] :reader
    #   The coercer to be used by method getter
    # @option [Proc, Symbol, String] :writer
    #   The coercer to be used by method writer
    #
    # @return [undefined]
    def attribute(name, coerce: nil, reader: nil, writer: nil, strict: nil)
      attribute_reader name, coerce: (reader || coerce), strict: strict
      attribute_writer name, coerce: (writer || coerce), strict: strict
    end

    # @!method attribute_reader(name, coerce: nil, strict: nil)
    # Declares the attribute getter
    #
    # @param  [Symbol, String] name
    #   The name of the attribute
    # @option [Proc, Symbol, String] :coerce
    #   The coercer for the attribute
    # @option [Boolean] :strict
    #   Whether +nil+ should be coerced
    #
    # @return [undefined]
    def attribute_reader(name, **options)
      __declare_reader name, Coercer.new(options)
      __readers << name.to_sym
    end

    # @!method attribute_writer(name, coerce: nil, strict: nil)
    # Declares the attribute writer
    #
    # @param  (see #attribute_reader)
    # @option (see #attribute_reader)
    #
    # @return [undefined]
    def attribute_writer(name, **options)
      __declare_writer name, Coercer.new(options)
      __writers << name.to_sym
    end

    private

    def __readers
      @__readers ||= begin
        default = superclass.send :__readers if superclass.is_a? Eigindir::API
        default || []
      end
    end

    def __writers
      @__writers ||= begin
        default = superclass.send :__writers if superclass.is_a? Eigindir::API
        default || []
      end
    end

    def __declare_reader(name, coercer)
      return attr_reader(name) unless coercer
      define_method(name) do
        coercer.call self, instance_variable_get(:"@#{ name }")
      end
    end

    def __declare_writer(name, coercer)
      return attr_writer(name) unless coercer
      define_method("#{ name }=") do |value|
        instance_variable_set :"@#{ name }", coercer.call(self, value)
      end
    end

  end # module API

end # module Eigindir
