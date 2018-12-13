@state = nil
@rules = {}

File.open('day12.txt').each do |line|
  if line =~ /^initial state: ([#\.]+)/
    @state = $1
  elsif line =~ /([#\.]+) => ([#\.])/
    @rules[$1] = $2
  end
end

def grow(state, rules)
  state = '...' + state + '...'
  new_state = '.' * state.size

  (2 .. (state.size-3)).each do |center|
    str = state[(center-2)..(center+2)]
    new_state[center] = rules[str] || '.'
  end

  first_plant = new_state.index('#')
  last_plant = new_state.rindex('#')
  [new_state[first_plant..last_plant], first_plant-3]
end

offset = 0
20.times do |i|
  (@state, delta) = grow(@state, @rules)
  offset += delta
end

total = 0
@state.split(//).each_with_index do |c, i|
  total += i + offset if c == '#'
end

puts("Part 1: #{total}")

File.open('day12.txt').each do |line|
  if line =~ /^initial state: ([#\.]+)/
    @state = $1
    break
  end
end

offset = 0
fixpoint_state = nil
fixpoint_generation = nil
fixpoint_offset_delta = nil
20000.times do |i|
  old_state = @state
  old_offset = offset
  (@state, delta) = grow(@state, @rules)
  if old_state == @state
    fixpoint_state = @state
    fixpoint_generation = i
    fixpoint_offset_delta = delta
    break
  end
  offset += delta
end

offset += (50_000_000_000 - fixpoint_generation) * fixpoint_offset_delta
total = 0
@state.split(//).each_with_index do |c, i|
  total += i + offset if c == '#'
end

puts("Part 2: #{total}")
