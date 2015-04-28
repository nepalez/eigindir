# encoding: utf-8

describe Eigindir do

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

end # describe Eigindir
