# frozen_string_literal: true

guard "rspec", cmd: "bundle exec rspec" do
  watch("spec/spec_helper.rb") { "spec" }
  watch("config/routes.rb") { "spec/controllers" }
  watch("app/controllers/application_controller.rb") { "spec/controllers" }
  watch(%r{^spec/(.+)_spec\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)_decorator\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^(app|lib)/(.+)(\.rb|\.erb)$}) { |m| "spec/#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb" }
end
