require "wavey"

module DevHelpers
  def get_samples(wavey_method, scale = :large)
    channels = 1
    sample_rate =
      case scale
      when :small
        100
      when :large
        44100
      end

    frequency = 50 # Hz
    amplitude = 0.5 # 50% volume.
    duration  = 10 # seconds.

    Wavey.new(channels, sample_rate).send(wavey_method, frequency, amplitude, duration)
  end
  module_function :get_samples
  public :get_samples
end
