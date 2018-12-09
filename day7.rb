depends = {}
all_tasks = []
File.open('day7.txt').each do |line|
  if line =~ /Step (.) must be finished before step (.) can begin/
    depends[$2] ||= []
    depends[$2] << $1
    all_tasks << $1
    all_tasks << $2
  end
end

all_tasks.uniq!
depends.values.each(&:uniq!)

finished = []
while finished.size < all_tasks.size
  possible = all_tasks.select {|t| (depends[t] || []) - finished == [] } - finished
  finished << possible.sort.first
end

puts("Part 1: #{finished.join}")

workers = []
5.times {|id| workers << { id: id, task: nil, finished: 0 } }
clock = 0

finished = []
started = []

loop do
  ready = workers.select {|w| w[:finished] <= clock }
  ready.each {|w| finished << w[:task] if w[:task]; w[:task] = nil }

  break if finished.size == all_tasks.size
  possible = all_tasks.select {|t| (depends[t] || []) - finished == [] } - finished - started

  while possible.any? && ready.any?
    ready.first[:task] = possible.first
    started << possible.first
    ready.first[:finished] = clock + (possible.first.ord - 'A'.ord) + 61
    ready.shift
    possible.shift
  end

  clock += 1
end

puts("Part 2: #{clock}")
