grid = []
serial = 3463

301.times { grid << [nil] * 301 }

def level(x, y, serial)
  ((((x + 10) * y + serial) * (x + 10)) % 1000 / 100.0).floor - 5
end

(1..300).each do |y|
  (1..300).each do |x|
    grid[y][x] = level(x, y, serial)
  end
end

max = nil
x_max = nil
y_max = nil
(1..298).each do |y|
  (1..298).each do |x|
    total = grid[y][x] + grid[y][x+1] + grid[y][x+2] +
            grid[y+1][x] + grid[y+1][x+1] + grid[y+1][x+2] +
            grid[y+2][x] + grid[y+2][x+1] + grid[y+2][x+2]
    if !max || max < total
      max = total
      x_max = x
      y_max = y
    end
  end
end

def square_total(grid, x, y, size)
  total = 0
  (y..(y+size-1)).each do |yt|
    (x..(x+size-1)).each do |xt|
      total += grid[yt][xt]
    end
  end
  total
end

def max_of_size(grid, size)
  max = nil
  y_max = nil
  x_max = nil

  (1..(300-size-1)).each do |y|
    (1..(300-size-1)).each do |x|
      total = square_total(grid, x, y, size)
      if !max || max < total
        max = total
        x_max = x
        y_max = y
      end
    end
  end

  [x_max, y_max, max]
end

def progressive_max(grid, size)
  starts = []
  (1 .. size).each do |y|
    starts << grid[y][1..size].inject(&:+)
  end
  total = starts.inject(&:+)

  max = starts.inject(&:+)
  x_max = 1
  y_max = 1

  top = 1
  left = 1

  # puts starts.inspect
  # puts '-----'
  # puts grid[1][1..5].inspect
  # puts grid[2][1..5].inspect
  # puts grid[3][1..5].inspect
  # puts grid[4][1..5].inspect

  loop do
    if total > max
      max = total
      x_max = left
      y_max = top
    end

    if left + size == 300
      break if top + size == 300
      starts = []
      top += 1
      left = 1
      (top .. (top + size-1)).each do |y|
        starts << grid[y][1..size].inject(&:+)
      end
      total = starts.inject(&:+)
    else
      # # puts '====='
      # starts.each_with_index do |s, i|
      #   # puts [starts[i], grid[top + i][left-1], grid[top + i][left+size]].inspect
      #   starts[i] -= grid[top + i][left]
      #   starts[i] += grid[top + i][left+size]
      # end

      size.times do |i|
        total -= grid[top + i][left]
        total += grid[top + i][left+size]
      end

      left += 1

      # puts "~~~~~"
      # puts starts.inspect
      # break
    end
  end

  [x_max, y_max, max]
end

def max_size(grid)
  max = nil
  s_max = nil
  (1..299).each do |size|
    puts size
    total = progressive_max(grid, size)
    if !max || max.last < total.last
      max = total
      s_max = size
    end
  end
  max.pop
  max << s_max
  max
end

puts("Part 1: #{max_of_size(grid, 3)[0..2].join(',')}")
puts("Part 1: #{progressive_max(grid, 3)[0..1].join(',')}")


puts("Part 2: #{max_size(grid).join(',')}")
