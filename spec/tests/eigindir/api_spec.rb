# encoding: utf-8

describe Eigindir::API do

  let(:coercer) { ->(value) { value.to_s } }
  let(:klass) do
    Class.new do
      extend Eigindir::API

      private

      def coercer(value)
        value.to_s
      end
    end
  end

  subject { klass.new }

  shared_examples "adding readonly attribute :foo" do

    it "declares the getter" do
      expect(subject).to respond_to :foo
    end

    it "doesn't declare the setter" do
      expect(subject).not_to respond_to :foo=
    end

  end # shared example

  shared_examples "adding writeonly attribute :foo" do

    it "declares the setter" do
      expect(subject).to respond_to :foo=
    end

    it "doesn't declare the getter" do
      expect(subject).not_to respond_to :foo
    end

  end # shared example

  shared_examples "making :foo to coerce something" do

    it "coerces the getter" do
      subject.instance_eval "@foo = 1"
      expect(subject.foo).to eq "1"
    end

    it "doesn't coerce nil" do
      expect(subject.foo).to be_nil
    end

  end # shared example

  shared_examples "making :foo to coerce anything" do

    it "coerces the getter" do
      subject.instance_eval "@foo = 1"
      expect(subject.foo).to eq "1"
    end

    it "doesn't coerce nil" do
      expect(subject.foo).to eq ""
    end

  end # shared example

  shared_examples "making :foo= to coerce something" do

    it "coerces the setter" do
      subject.foo = 1
      expect(subject.instance_eval "@foo").to eq "1"
    end

    it "doesn't coerce nil" do
      subject.foo = nil
      expect(subject.instance_eval "@foo").to be_nil
    end

  end # shared example

  shared_examples "making :foo= to coerce anything" do

    it "coerces the setter" do
      subject.foo = 1
      expect(subject.instance_eval "@foo").to eq "1"
    end

    it "coerces nil" do
      subject.foo = nil
      expect(subject.instance_eval "@foo").to eq ""
    end

  end # shared example

  shared_examples "reporting a wrong coercer arity" do

    it "fails with ArgumentError" do
      expect { subject }.to raise_error ArgumentError
    end

    it "returns a proper error message" do
      begin
        subject
      rescue => error
        expect(error.message).to eq "Coercer should take exactly one argument"
      end
    end

  end # shared example

  shared_examples "reporting a wrong coercer type" do

    it "fails with TypeError" do
      expect { subject }.to raise_error TypeError
    end

    it "returns a proper error message" do
      begin
        subject
      rescue => error
        expect(error.message).to eq "1 is not a Proc, Symbol, or String"
      end
    end

  end # shared example

  describe ".attribute_reader" do

    context "without coercer" do

      before { klass.attribute_reader :foo }

      it_behaves_like "adding readonly attribute :foo"

    end # context

    context "with proc coercer" do

      before { klass.attribute_reader :foo, coerce: coercer.to_proc }

      it_behaves_like "adding readonly attribute :foo"
      it_behaves_like "making :foo to coerce something"

    end # context

    context "with lambda coercer" do

      before { klass.attribute_reader :foo, coerce: coercer }

      it_behaves_like "adding readonly attribute :foo"
      it_behaves_like "making :foo to coerce something"

    end # context

    context "with a symbolic coercer" do

      before { klass.attribute_reader :foo, coerce: :coercer }

      it_behaves_like "adding readonly attribute :foo"
      it_behaves_like "making :foo to coerce something"

    end # context

    context "with a string coercer" do

      before { klass.attribute_reader :foo, coerce: "coercer" }

      it_behaves_like "adding readonly attribute :foo"
      it_behaves_like "making :foo to coerce something"

    end # context

    context "in a strict mode" do

      before { klass.attribute_reader :foo, coerce: coercer, strict: true }

      it_behaves_like "adding readonly attribute :foo"
      it_behaves_like "making :foo to coerce anything"

    end # context

    context "with coercer that has a wrong type" do

      subject { klass.attribute_reader :foo, coerce: 1 }

      it_behaves_like "reporting a wrong coercer type"

    end # context

    context "with coercer that takes no attributes" do

      subject { klass.attribute_reader :foo, coerce: proc { 1 } }

      it_behaves_like "reporting a wrong coercer arity"

    end # context

    context "with coercer that takes more than one attribute" do

      subject { klass.attribute_reader :foo, coerce: proc { |_, _| 1 } }

      it_behaves_like "reporting a wrong coercer arity"

    end # context

    context "without method name" do

      it "fails with ArgumentError" do
        expect { klass.attribute_reader }.to raise_error ArgumentError
      end

    end # context

  end # describe .attribute_reader

  describe ".attribute_writer" do

    context "without coercer" do

      before { klass.attribute_writer :foo }

      it_behaves_like "adding writeonly attribute :foo"

    end # context

    context "with proc coercer" do

      before { klass.attribute_writer :foo, coerce: coercer.to_proc }

      it_behaves_like "adding writeonly attribute :foo"
      it_behaves_like "making :foo= to coerce something"

    end # context

    context "with lambda coercer" do

      before { klass.attribute_writer :foo, coerce: coercer }

      it_behaves_like "adding writeonly attribute :foo"
      it_behaves_like "making :foo= to coerce something"

    end # context

    context "with a symbolic coercer" do

      before { klass.attribute_writer :foo, coerce: :coercer }

      it_behaves_like "adding writeonly attribute :foo"
      it_behaves_like "making :foo= to coerce something"

    end # context

    context "with a string coercer" do

      before { klass.attribute_writer :foo, coerce: "coercer" }

      it_behaves_like "adding writeonly attribute :foo"
      it_behaves_like "making :foo= to coerce something"

    end # context

    context "in a strict mode" do

      before { klass.attribute_writer :foo, coerce: coercer, strict: true }

      it_behaves_like "adding writeonly attribute :foo"
      it_behaves_like "making :foo= to coerce anything"

    end # context

    context "with coercer of a wrong type" do

      subject { klass.attribute_writer :foo, coerce: 1 }

      it_behaves_like "reporting a wrong coercer type"

    end # context

    context "with coercer that takes no attributes" do

      subject { klass.attribute_writer :foo, coerce: proc { 1 } }

      it_behaves_like "reporting a wrong coercer arity"

    end # context

    context "with coercer that takes more than one attribute" do

      subject { klass.attribute_writer :foo, coerce: proc { |_, _| 1 } }

      it_behaves_like "reporting a wrong coercer arity"

    end # context

    context "without method name" do

      it "fails with ArgumentError" do
        expect { klass.attribute_writer }.to raise_error ArgumentError
      end

    end # context

  end # describe .attribute_reader

  describe ".attribute" do

    let(:other) { proc { |value| value.to_i } }

    context "without coercers" do

      after { klass.attribute :foo }

      it "calls .attribute_writer without coercer" do
        expect(klass).to receive(:attribute_writer)
          .with(:foo, coerce: nil, strict: nil)
          .once
      end

      it "calls .attribute_reader without coercer" do
        expect(klass).to receive(:attribute_reader)
          .with(:foo, coerce: nil, strict: nil)
          .once
      end

    end # context

    context "with :coerce" do

      after { klass.attribute :foo, coerce: coercer, strict: true }

      it "calls .attribute_writer with coercer" do
        expect(klass)
          .to receive(:attribute_writer)
          .with(:foo, coerce: coercer, strict: true)
          .once
      end

      it "calls .attribute_reader with coercer" do
        expect(klass)
          .to receive(:attribute_reader)
          .with(:foo, coerce: coercer, strict: true)
          .once
      end

    end # context

    context "with :writer" do

      after do
        klass.attribute :foo, coerce: coercer, writer: other, strict: true
      end

      it "calls .attribute_writer with specific coercer" do
        expect(klass)
          .to receive(:attribute_writer)
          .with(:foo, coerce: other, strict: true)
          .once
      end

      it "calls .attribute_reader with common coercer" do
        expect(klass).to receive(:attribute_reader)
          .with(:foo, coerce: coercer, strict: true)
          .once
      end

    end # context

    context "with :reader" do

      after do
        klass.attribute :foo, coerce: coercer, reader: other, strict: true
      end

      it "calls .attribute_writer with common coercer" do
        expect(klass)
          .to receive(:attribute_writer)
          .with(:foo, coerce: coercer, strict: true)
          .once
      end

      it "calls .attribute_reader with specific coercer" do
        expect(klass)
          .to receive(:attribute_reader)
          .with(:foo, coerce: other, strict: true)
          .once
      end

    end # context

  end # describe .attribute

end # describe Eigindir::API
