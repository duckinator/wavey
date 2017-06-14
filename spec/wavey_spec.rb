require "spec_helper"
require "json"

RSpec.describe Wavey do
  RSpec.configure do |c|
    c.include DevHelpers
  end

  # get_samples(wavey_method) is from DevHelpers.

  def get_fixture(wavey_method)
    file = File.expand_path("../fixtures/#{wavey_method}.json", __dir__)

    JSON.parse(File.read(file))
  end

  it "generates the correct waveforms" do
    expect(get_samples("sawtooth")).to eq(get_fixture("sawtooth"))
    expect(get_samples("silence")).to eq(get_fixture("silence"))
    expect(get_samples("sine")).to eq(get_fixture("sine"))
    expect(get_samples("square")).to eq(get_fixture("square"))
    expect(get_samples("triangle")).to eq(get_fixture("triangle"))
  end
end
