require "wavey/version"

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
    Array.new(duration * sample_rate) { |index|
      # ??? TODO
    }
  end

  # Generate a sine wave.
  def sine(frequency, amplitude, duration)
    two_pi = Math.atan(1) * 8.0 

    n_point = 100 # TODO: wtf is this even?

    Array.new(duration * sample_rate) { |index|
      x = index / n_point

      if x < 0 || x > 1
        0
      else
        amplitude * Math.sin(two_pi * frequency) * x
      end
    }
  end

  # Generate a square wave.
  def square(frequency, amplitude, duration)
    Array.new(duration * sample_rate) { |index|
      # ??? TODO
    }
  end

  # Generate a triangle wave.
  def triangle(frequency, amplitude, duration)
    Array.new(duration * sample_rate) { |index|
      # ??? TODO
    }
  end


  # Generate silence.
  # TODO: maybe put duration first everywhere so we can =nil the other two vars?
  def silence(_frequency, _amplitude, duration)
    Array.new(duration * sample_rate, 0)
  end

  # THIS API IS GARBAGE AND NEEDS REPLACING.
  def save(filename, wave_method, frequency, amplitude, duration)
    unless defined?(WaveFile)
      raise "Wavey#save requires the wavefile gem."
    end

    samples = send(wave_method, frequency, amplitude, duration)

    WaveFile::Writer.new(filename, WaveFile::Format.new(channels, :pcm_16, sample_rate)) do |writer|
      buffer_format = WaveFile::Format.new(channels, :float, sample_rate)

      buffer = WaveFile::Buffer.new(samples, buffer_format)
      writer.write(buffer)
    end
  end
end
