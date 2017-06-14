require "bundler/gem_tasks"
require "rspec/core/rake_task"

$: << File.join(__dir__, 'lib')
require 'wavey'

require 'json'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


def get_samples(wavey_method)
  frequency = 50 # Hz
  amplitude = 0.5 # 50% volume.
  duration  = 10 # seconds.

  Wavey.new.send(wavey_method, frequency, amplitude, duration)
end

def save_fixtures(wavey_method)
  file = File.join(__dir__, 'fixtures', "#{wavey_method}.json")

  File.open(file, 'w') do |f|
    f.puts get_samples(wavey_method).to_json
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
