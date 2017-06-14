require "wavey"

module DevHelpers
  def get_samples(wavey_method)
    frequency = 50 # Hz
    amplitude = 0.5 # 50% volume.
    duration  = 10 # seconds.

    Wavey.new.send(wavey_method, frequency, amplitude, duration)
  end
  module_function :get_samples
  public :get_samples
end
