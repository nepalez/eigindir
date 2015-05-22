Eigindir
========

[![Gem Version](https://img.shields.io/gem/v/eigindir.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/eigindir/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/eigindir.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/eigindir.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/eigindir.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/eigindir.svg)][inch]

[codeclimate]: https://codeclimate.com/github/nepalez/eigindir
[coveralls]: https://coveralls.io/r/nepalez/eigindir
[gem]: https://rubygems.org/gems/eigindir
[gemnasium]: https://gemnasium.com/nepalez/eigindir
[travis]: https://travis-ci.org/nepalez/eigindir
[inch]: https://inch-ci.org/github/nepalez/eigindir

Coercible PORO attributes.

Synopsis
--------

This is a tiny [virtus]-inspired library
for PORO attributes' definition and coersion.

Like [virtus] it declares attributes, and coerces their values.
Unlike [virtus] it uses different coersion mechanism, and does nothing else.

[virtus]: https://github.com/solnic/virtus

```ruby
class Foo
  include Eigindir

  attribute(
    :bar,
    writer: ->(v) { v.to_i + 1 },
    reader: ->(v) { v.to_s     }
  )
end

foo = Foo.new

# the setter coerced given value:
foo.bar = "10"
foo.instance_eval "@bar" # => 11
# the getter coerced stored value:
foo.instance_eval # => "11"

# attributes getter and setter are defined as well:
foo.attributes = { "bar" => 5 }
foo.attributes # => { bar: "6" }
```

The module doesn't define the initializer.
You're free to define in a following way:

```ruby
class Foo
  include Eigindir

  def initializer(**options)
    self.attributes = options
  end
end
```

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "eigindir"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install eigindir
```

Usage
-----

### Base Use

`attribute`, `attribute_reader` and `attribute_writer` are like
`attr_accessor`, `attr_reader` and `attr_writer`:

```ruby
class Foo
  include Eigindir

  attribute :bar
  attribute_reader :baz
  attribute_writer :qux
end

foo = Foo.new

foo.bar = 1
foo.bar # => 1

foo.baz = 1 # <NoMethodError>
foo.baz # => nil

foo.qux = 1
foo.instance_eval "@qux" # => 1
foo.qux # <NoMethodError>
```

### Attributes Declaration

The `attributes` and `attributes=` ignore all keys not declared as `attribute`.

```ruby
class Foo
  include Eigindir

  attribute :bar
  attr_accessor :baz
end

foo = Foo.new
foo.attributes = { bar: 1, baz: 2 }
foo.bar # => 1
foo.baz # => nil

foo.baz = 2
foo.baz # => 2
foo.attributes # => { bar: 1 }
```

The methods ignore attributes that has no getters or setters correspondingly:

```ruby
class Foo
  include Eigindir

  attribute_reader :bar
  attribute_writer :baz
end

foo = Foo.new
foo.attributes = { bar: 1, baz: 1 }

# baz has no getter,
# bar value is not assigned because it has no setter:
foo.attributes = { bar: nil }
```

The `attributes=` accepts hash with any stringified keys and symbolizes them:

```ruby
class Foo
  include Eigindir

  attribute :bar
  attribute :baz
end

foo = Foo.new
foo.attributes = { bar: "1", "bar" => 2 }
# The setter symbolizes keys to :bar and uses last value:
foo.attributes # => { bar: 2 }
```

### Base Coersion

All class methods: `attribute`, `attribute_reader` and `attribute_writer`
accepts the `:coerce` key:

```ruby
class Foo
  include Eigindir

  attribute :bar, coerce: ->(val) { val.to_i + 1 }
end
```

The setter coerces given value:

```ruby
foo = Foo.new

foo.bar = "1"
foo.instance_eval "@bar" # => 2
```

The getter coerces stored variable:

```ruby
foo.instance_eval "@bar" # => 2
foo.bar # => 3
```

A coercer can be set either as proc or lambda, or by instance method name.
The following declarations are equivalent:

```ruby
class Foo
  include Eigindir

  attribute :bar, coerce: ->(value) { value.to_s }
  attribute :bar, coerce: lambda { |value| value.to_s }
  attribute :bar, coerce: proc { |value| value.to_s }
  attribute :bar, coerce: :coercer
  attribute :bar, coerce: "coercer"

  private

  def coercer(value)
    value.to_s
  end
end
```

### Separate Coersion

The `attribute` class method also takes `:reader` and `:writer`.
Every option sets its own coersion for the corresponding direction:

```ruby
class Foo
  include Eigindir

  attribute(
    :bar,
    writer: ->(val) { val.to_i + 1 }
    reader: ->(val) { val.to_s     }
  )
end

foo = Foo.new

# The setter uses the :writer coercer:
foo.bar = "10"
foo.instance_eval "@bar" # => 11

# The getter uses the :reader coercer:
foo.bar # => "11"
```

You can use `writer` coersion to control value type in a [defensive way]:

```ruby
class Foo
  include Eigindir
  attribute :bar, writer: ->(value) { value.is_a? Bar ? value : fail(TypeError) }
end
```

[defensive way]: http://www.erlang.se/doc/programming_rules.shtml#HDR11

### Coersion of nil

Because `nil` stands for *nothing*, it is not coerced by default:

```ruby
class Foo
  include Eigindir

  attribute :bar, coerce: ->(value) { value.to_s }
end

foo = Foo.new
foo.bar = nil
foo.instance_eval "@bar" # => nil
foo.bar # => nil
```

Use `strict: true` option to coerce `nil` as well:

```ruby
class Foo
  include Eigindir

  attribute :baz, coerce: ->(value) { value.to_s }, strict: true
end

foo = Foo.new
foo.bar = nil
foo.instance_eval "@bar" # => ""
foo.bar # => ""
```

This can be used to set default values explicitly either by getter or setter:

```ruby
class Foo
  include Eigindir

  attribute :bar, reader: proc { |val| val || 1 }, strict: true
  attribute :baz, writer: proc { |val| val || 1 }, strict: true
end

foo = Foo.new

# The getter's default is pretty virtual:
foo.bar = nil
foo.instance_eval "@bar" # => nil
foo.bar # => 1

# While the setter's is persistent:
foo.baz = nil
foo.instance_eval "@baz" # => 1
foo.baz # => 1
```

Compatibility
-------------

Tested under [MRI rubies 2.1+](.travis.yml) only.

It uses [Ruby 2.1+ refinements] that aren't yet supported by Rubinius and JRuby.

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[Ruby 2.1+ refinements]: http://ruby-doc.org/core-2.1.1/doc/syntax/refinements_rdoc.html
[RSpec]: http://rspec.org
[hexx-suit]: https://github.com/nepalez/hexx-suit

Contributing
------------

* Fork the project.
* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE).
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version
  in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Credits
-------

Many thanks to Icelandic for
[the name of the module](https://translate.google.ru/?hl=en#is/en/eigindir).

License
-------

See the [MIT LICENSE](LICENSE).


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/nepalez/eigindir/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

