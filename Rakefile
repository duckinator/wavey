require "bundler/gem_tasks"
require "rspec/core/rake_task"

$: << File.expand_path('./lib', __dir__)
require 'wavey'

require File.expand_path('./utils/helpers.rb', __dir__)

require 'json'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

def save_fixtures(wavey_method)
  file = File.join(__dir__, 'fixtures', "#{wavey_method}.json")

  File.open(file, 'w') do |f|
    f.puts DevHelpers.get_samples(wavey_method).to_json
  end
end

desc "Generate samples for tests."
task :generate_samples do
  warn "This doesn't actually check if they're valid."
  warn "After all, this is for generating data to run tests against."

  %w[sawtooth sine square triangle silence].each do |wavey_method|
    save_fixtures(wavey_method)
  end
end
