# encoding: utf-8

describe Eigindir do

  let(:coercer) { ->(value) { value.to_s } }
  let(:klass) do
    Class.new do
      include Eigindir

      private

      def coercer(value)
        value.to_s
      end
    end
  end

  subject(:instance) { klass.new }

  describe ".included" do

    it "extends class with API" do
      expect(klass).to be_kind_of Eigindir::API
    end

  end # describe .included

  describe "#attributes" do

    subject do
      instance.instance_eval "@foo = 1"
      instance.attributes
    end

    it "returns coerced attributes" do
      klass.attribute :foo, coerce: ->(val) { val.to_s }
      expect(subject).to eq(foo: "1")
    end

    it "returns attributes with getter" do
      klass.attribute_reader :foo, coerce: ->(val) { val.to_s }
      expect(subject).to eq(foo: "1")
    end

    it "skips attributes without getter" do
      klass.attribute_writer :foo, coerce: ->(val) { val.to_s }
      expect(subject).to eq({})
    end

    it "skips non-attributes" do
      klass.send :attr_accessor, :foo
      expect(subject).to eq({})
    end

    it "returns attributes defined in superclass" do
      parent   = Class.new { include Eigindir }
      parent.attribute :foo, coerce: ->(_) { 1 }, strict: true
      klass    = Class.new(parent) { attribute :bar }

      pater = parent.new
      child = klass.new

      expect(pater.attributes).to eq(foo: 1)
      expect(child.attributes).to eq(foo: 1, bar: nil)
    end

  end # describe #attributes

  describe "#attributes=" do

    subject do
      instance.attributes = { "foo" => 1 }
      instance.instance_eval "@foo"
    end

    it "sets values to coerced attributes" do
      klass.attribute :foo, coerce: ->(val) { val.to_s }
      expect(subject).to eq "1"
    end

    it "sets values to attributes with setter" do
      klass.attribute_writer :foo, coerce: ->(val) { val.to_s }
      expect(subject).to eq "1"
    end

    it "skips attributes without setter" do
      klass.attribute_reader :foo, coerce: ->(val) { val.to_s }
      expect(subject).to be_nil
    end

    it "skips non-attributes" do
      klass.send :attr_accessor, :foo
      expect(subject).to be_nil
    end

  end # describe #attributes=

end # describe Eigindir
