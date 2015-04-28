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
module Eigindir

  # @!parse extend Eigindir::API
  # @private
  def self.included(klass)
    klass.extend API
  end

end # module Eigindir
