@map = []

File.open('day15.txt').each do |line|
  next if line.strip == ''
  map << line.strip.split(//)
end

def unit_order(map)
  units = []
  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      units << [x, y] if cell == 'G' || cell == 'E'
    end
  end
  units
end

def round(map)
  units = unit_order(map)
  units.each do |unit|

  end
end
