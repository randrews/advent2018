require 'date'

lines = File.read('day4.txt').split("\n").sort_by{|ln| ln =~ /\[(.*?)\]/; DateTime.parse($1) }

events = []
current_guard = nil
lines.each do |line|
  if line =~ /Guard #(\d+) begins/
    current_guard = $1.to_i
    events << { event: :newday, guard: current_guard }
  elsif line =~ /(\d+)\] falls asleep/
    events << { event: :asleep, guard: current_guard, minute: $1.to_i }
  elsif line =~ /(\d+)\] wakes up/
    events << { event: :awake, guard: current_guard, minute: $1.to_i }
  end
end

schedules = {}
minute = nil
events.each do |event|
  if event[:event] == :newday
    minute = 0
    schedules[event[:guard]] ||= []
    schedules[event[:guard]] << []
  elsif event[:event] == :asleep
   minute = event[:minute]
  elsif event[:event] == :awake
    sch = schedules[event[:guard]].last
    (minute .. event[:minute]-1).each {|m| sch << m }
    minute = event[:minute] + 1
  end
end

# Part 1
most_asleep = schedules.keys.max_by {|guard| schedules[guard].map(&:size).inject(&:+) }
asleep_minutes = Hash.new(0)
schedules[most_asleep].inject(&:+).each {|min| asleep_minutes[min] += 1 }
most_asleep_minute = asleep_minutes.keys.max_by {|m| asleep_minutes[m] }
puts("Part 1: #{most_asleep} * #{most_asleep_minute} = #{most_asleep * most_asleep_minute}")

# Part 2
sleep_freq = {}
schedules.each do |guard, days|
  next if days.inject(&:+).size == 0
  mins = Hash.new(0)
  days.inject(&:+).each {|min| mins[min] += 1 }
  most_minute = mins.keys.max_by {|m| mins[m] }
  sleep_freq[guard] = [most_minute, mins[most_minute]]
end
most_freq_asleep = sleep_freq.keys.max_by {|g| sleep_freq[g][1] }
puts("Part 2: #{most_freq_asleep} * #{sleep_freq[most_freq_asleep][0]} = #{most_freq_asleep * sleep_freq[most_freq_asleep][0]}")
  
