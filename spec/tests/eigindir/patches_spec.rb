# encoding: utf-8

describe Eigindir::Patches do
  using described_class

  describe "to Hash" do

    describe "#normalize" do

      let(:hash) { { "foo" => "foo", "bar" => { "baz" => "qux" } } }

      it "symbolizes all keys" do
        expect(hash.normalize).to eq(foo: "foo", bar: { "baz" => "qux" })
      end

    end # describe #normalize

    describe "#slice" do

      let(:hash) { { foo: "foo", bar: "bar" } }

      it "returs a hash with given keys only" do
        expect(hash.slice :foo).to eq(foo: "foo")
      end

      it "ignores unknown keys" do
        expect(hash.slice :baz).to eq({})
      end

    end # describe #slice

  end # describe Hash

end # describe Eigindir::Patches
