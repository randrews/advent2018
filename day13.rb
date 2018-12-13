@tracks = []

def init()
  tracks = []
  carts = []

  File.open('day13.txt').each do |line|
    tracks << line.split(//)
  end

  tracks.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == '^'
        carts << { x: x, y: y, dir: :n, turn: 1 }
        row[x] = '|'
      elsif cell == 'v'
        carts << { x: x, y: y, dir: :s, turn: 1 }
        row[x] = '|'
      elsif cell == '<'
        carts << { x: x, y: y, dir: :w, turn: 1 }
        row[x] = '-'
      elsif cell == '>'
        carts << { x: x, y: y, dir: :e, turn: 1 }
        row[x] = '-'
      end
    end
  end

  [tracks, carts]
end

def tick(tracks, carts)
  left_turn = { n: :w, w: :s, s: :e, e: :n }
  right_turn = { n: :e, e: :s, s: :w, w: :n }

  carts.sort! do |a, b|
    if a[:y] == b[:y]
      a[:x] <=> b[:x]
    else
      a[:y] <=> b[:y]
    end
  end

  collisions = []

  carts.each do |cart|
    next if cart[:dead]
    cell = tracks[cart[:y]][cart[:x]]

    if cart[:dir] == :n
      cart[:y] -= 1
    elsif cart[:dir] == :s
      cart[:y] += 1
    elsif cart[:dir] == :e
      cart[:x] += 1
    elsif cart[:dir] == :w
      cart[:x] -= 1
    end

    newcell = tracks[cart[:y]][cart[:x]]
    if newcell == '|' || newcell == '-'
      # Don't turn
    elsif newcell == '/'
      if cart[:dir] == :n
        cart[:dir] = :e
      elsif cart[:dir] == :w
        cart[:dir] = :s
      elsif cart[:dir] == :s
        cart[:dir] = :w
      elsif cart[:dir] == :e
        cart[:dir] = :n
      end
    elsif newcell == '\\'
      if cart[:dir] == :s
        cart[:dir] = :e
      elsif cart[:dir] == :w
        cart[:dir] = :n
      elsif cart[:dir] == :n
        cart[:dir] = :w
      elsif cart[:dir] == :e
        cart[:dir] = :s
      end
    elsif newcell == '+'
      if cart[:turn] % 3 == 1
        cart[:dir] = left_turn[cart[:dir]]
      elsif cart[:turn] % 3 == 2
        # Don't turn
      elsif cart[:turn] % 3 == 0
        cart[:dir] = right_turn[cart[:dir]]
      end
      cart[:turn] += 1
    end

    collided = carts.select {|other| other[:x] == cart[:x] && other[:y] == cart[:y] && other != cart }
    if collided.first
      collisions << "#{cart[:x]},#{cart[:y]}"
      collided.first[:dead] = true
    end
  end

  return collisions
end

def display(tracks, carts)
  by_coord = {}
  carts.each do |cart|
    by_coord["#{cart[:x]},#{cart[:y]}"] ||= []
    by_coord["#{cart[:x]},#{cart[:y]}"] << cart
  end

  tracks.each_with_index do |row, y|
    line = []
    row.each_with_index do |cell, x|
      if by_coord["#{x},#{y}"]
        if by_coord["#{x},#{y}"].length > 1
          line << 'X'
        else
          case by_coord["#{x},#{y}"][0][:dir]
          when :n then line << '^'
          when :s then line << 'v'
          when :e then line << '>'
          when :w then line << '<'
          end
        end
      else
        line << row[x]
      end
    end
    puts line.join
  end
end

(@tracks, @carts) = init
part1 = nil
loop do
  part1 = tick(@tracks, @carts)
  break if part1.any?
end

puts("Part 1: #{part1.first}")

(@tracks, @carts) = init
loop do
  collisions = tick(@tracks, @carts)

  collisions.each do |collision|
    (x,y) = collision.split(',').map(&:to_i)
    @carts.reject! {|cart| cart[:x] == x && cart[:y] == y }
  end

  break if @carts.length == 1
end

puts("Part 2: #{@carts.first[:x]},#{@carts.first[:y]}")
