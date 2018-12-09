coords = []
id = 'a'
File.open('day6.txt').each do |line|
  if line =~ /(\d+), (\d+)/
    coords << [$1.to_i, id, $2.to_i]
    id = id.succ
  end
end

width = coords.map(&:first).max + 1
height = coords.map(&:last).max + 1
map = []
(1..height).each { map << ([nil] * width) }

def dist(x1, y1, x2, y2)
  (x1-x2).abs + (y1-y2).abs
end

(0..(height-1)).each do |y|
  (0..(width-1)).each do |x|
    distances = coords.map {|coord| [coord[1], dist(x, y, coord.first, coord.last)] }.sort_by(&:last)
    if distances[0][1] == distances[1][1]
      map[y][x] = '.'
    else
      map[y][x] = distances[0][0]
    end
  end
end

ignores = []
(0..width-1).each do |x|
  ignores << map[0][x]
  ignores << map[height-1][x]
end

(0..height-1).each do |y|
  ignores << map[y][0]
  ignores << map[y][width-1]
end

ignores = ignores.uniq

counts = Hash.new(0)
(0..(height-1)).each do |y|
  (0..(width-1)).each do |x|
    next if ignores.include?(map[y][x])
    counts[map[y][x]] += 1
  end
end

puts("Part 1: #{counts.values.max}")

e_edge = coords.map(&:first).max + 10000 / coords.size
w_edge = coords.map(&:first).min - 10000 / coords.size
n_edge = coords.map(&:last).min - 10000 / coords.size
s_edge = coords.map(&:last).max + 10000 / coords.size

safe = 0
(n_edge..s_edge).each do |y|
  (w_edge..e_edge).each do |x|
    distances = coords.map {|coord| dist(x, y, coord.first, coord.last) }.inject(&:+)
    safe += 1 if distances < 10000
  end
end

puts("Part 2: #{safe}")
