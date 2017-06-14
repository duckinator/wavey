require "wavey/version"
require "waveform"

class Wavey
  attr_accessor :channels, :sample_rate

  # +channels+ is the number of audio channels (defaults to 1, mono).
  # +sample_rate+ is the sample rate, defaults to 44100.
  def initialize(channels = 1, sample_rate = 44100)
    @channels = channels
    @sample_rate = sample_rate
  end

  # Generate a sawtooth wave.
  def sawtooth(frequency, amplitude, duration)
    period_samples = sample_rate / frequency

    Array.new(duration * sample_rate) { |index|
      2 * ((index.to_f / period_samples) - (0.5 + (index.to_f / period_samples)).floor) * amplitude
    }
  end

  # Generate a sine wave.
  def sine(frequency, amplitude, duration)
    two_pi = Math.atan(1) * 8.0

    Array.new(duration * sample_rate) { |index|
      amplitude.to_f * Math.sin(two_pi * frequency * (index.to_f / sample_rate))
    }
  end

  # Generate a square wave.
  def square(frequency, amplitude, duration)
    period_samples = sample_rate / frequency

    Array.new(duration * sample_rate) { |index|
      if (index % period_samples) > (period_samples / 2)
        amplitude
      else
        -amplitude
      end
    }
  end

  # Generate a triangle wave.
  def triangle(frequency, amplitude, duration)
    period_samples = sample_rate / frequency

    Array.new(duration * sample_rate) { |index|
      (1.0 - 2 * (1 - (index.to_f % period_samples) / (period_samples.to_f / 2)).abs) * amplitude
    }
  end


  # Generate silence.
  # TODO: maybe put duration first everywhere so we can =nil the other two vars?
  def silence(_frequency, _amplitude, duration)
    Array.new(duration * sample_rate, 0)
  end

  # THIS API IS GARBAGE AND NEEDS REPLACING.
  def save(filename, wave_method, frequency, amplitude, duration)
    samples = send(wave_method, frequency, amplitude, duration)

    WaveFile::Writer.new(filename, WaveFile::Format.new(channels, :pcm_16, sample_rate)) do |writer|
      buffer_format = WaveFile::Format.new(channels, :float, sample_rate)

      buffer = WaveFile::Buffer.new(samples, buffer_format)
      writer.write(buffer)
    end
  end
end
