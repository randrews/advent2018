#!/usr/bin/ruby

changes = []

File.open('day1.txt').each do |line|
  changes << line.to_i
end

# Part 1:
puts "Part 1: #{changes.inject(&:+)}"

# Part 2:
freq = 0
freqs = { 0 => true }
part2 = nil

loop do
  changes.each do |change|
    freq += change
    if !part2 && freqs[freq]
      puts "Part 2: #{freq}"
      exit(0)
    else
      freqs[freq] = true
    end
  end
end
