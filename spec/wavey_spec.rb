require "spec_helper"
require "json"

RSpec.shared_examples "waveform generation" do |scale|
  RSpec.configure do |c|
    c.include DevHelpers
  end

  # get_samples(wavey_method) is from DevHelpers.

  def get_fixture(wavey_method, scale)
    file = File.expand_path("../fixtures/#{scale}-#{wavey_method}.json", __dir__)

    JSON.parse(File.read(file))
  end

  it "generates the correct waveforms" do
    expect(get_samples("sawtooth", scale)).to eq(get_fixture("sawtooth", scale))
    expect(get_samples("silence", scale)).to eq(get_fixture("silence", scale))
    expect(get_samples("sine", scale)).to eq(get_fixture("sine", scale))
    expect(get_samples("square", scale)).to eq(get_fixture("square", scale))
    expect(get_samples("triangle", scale)).to eq(get_fixture("triangle", scale))
  end
end

RSpec.describe Wavey do
  include_examples "waveform generation", :small
  include_examples "waveform generation", :large
end
