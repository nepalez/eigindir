# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/tests/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/tests/#{ m[1] }_spec.rb"
  end

  watch(%r{^lib/\w+\.rb$})     { "spec" }
  watch("spec/spec_helper.rb") { "spec" }

end # guard :rspec
