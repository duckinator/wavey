require "wavey/version"
require "wavefile"

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
      time = index.to_f / period_samples

      2 * (time - (0.5 + time).floor) * amplitude
    }
  end

  # Generate a sine wave.
  def sine(frequency, amplitude, duration)
    two_pi = Math::PI * 2

    # sin(two_pi * frequency * (index.to_f / sample_rate))
    # ==
    # sin((two_pi * frequency / sample_rate) * index)
    #
    # Pull out (two_pi * frequency / sample_rate) because it's constant.
    sin_div_part = two_pi * frequency / sample_rate

    Array.new(duration * sample_rate) { |index|
      amplitude * Math.sin(sin_div_part * index)
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
      (1.0 - 2 * (1 - (index.to_f % period_samples) / (period_samples / 2)).abs) * amplitude
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

    save_samples(filename, samples)
  end

  def save2(filename, data)
    results = data.map { |(wave_method, frequency, amplitude, duration, offset)|
      offset_array = Array.new(0, offset * sample_rate)
      offset_array + send(wave_method, frequency, amplitude, duration)
    }

    max_length = results.map(&:length).max

    samples = Array.new(max_length, 0).zip(*results).map { |*args| args.reduce(&:|) }

    save_samples(filename, samples)
  end

  def save_samples(filename, samples)
    WaveFile::Writer.new(filename, WaveFile::Format.new(channels, :pcm_16, sample_rate)) do |writer|
      buffer_format = WaveFile::Format.new(channels, :float, sample_rate)

      buffer = WaveFile::Buffer.new(samples, buffer_format)
      writer.write(buffer)
    end
  end
end
