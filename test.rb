#!/usr/bin/env ruby

$: << './lib'
require 'wavey'

x = Wavey.new

data = [
# [method, freq, amp, dur, offset]
  [:sine, 120, 0.5, 10, 0]
]

x.save2('test.wav', data)
