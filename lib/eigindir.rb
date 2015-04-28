# encoding: utf-8

require_relative "eigindir/patches"
require_relative "eigindir/coercer"
require_relative "eigindir/api"

# Module Eigindir provides PORO attributes declaration and coersion
#
# @example
#   class Foo
#     include Eigindir
#
#     attribute(
#       :foo,
#       writer: proc { |val| val.to_i + 1 },
#       reader: proc { |val| val.to_s     }
#     )
#   end
#
# @author Andrew Kozin <Andrew.Kozin@gmail.com>
#
# @api public
module Eigindir
  using Patches

  # Returns the hash of the object's attributes
  #
  # @return [Hash]
  def attributes
    __readers.zip(__readers.map(&method(:public_send))).to_h
  end

  # Assigns attributes from hash
  #
  # Unknown attributes are ignored
  #
  # @param [Hash] options
  #
  # @return [self] itself
  def attributes=(options)
    options
      .normalize
      .slice(*__writers)
      .each { |key, value| public_send :"#{ key }=", value }
  end

  # @!parse extend Eigindir::API
  # @private
  def self.included(klass)
    klass.extend API
  end

  private

  def __readers
    self.class.__send__ :__readers
  end

  def __writers
    self.class.__send__ :__writers
  end

end # module Eigindir
