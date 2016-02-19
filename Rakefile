require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :spec

task :milight_setup do
  puts "setup milight wifi."

  $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

  require 'milight/bridge_box'
  Milight::BridgeBox.setup
end
