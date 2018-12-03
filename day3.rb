claims = []
File.open('day3.txt').each do |line|
  if line =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
    claims << { id: $1.to_i,
                x: $2.to_i,
                y: $3.to_i,
                w: $4.to_i,
                h: $5.to_i }
  end
end

sheet = [0] * 1000 * 1000
claims.each do |claim|
  (claim[:x] .. (claim[:x]+claim[:w]-1)).each do |x|
    (claim[:y] .. (claim[:y]+claim[:h]-1)).each do |y|
      sheet[x+y*1000] += 1
    end
  end
end

overclaimed = sheet.select {|n| n > 1}.size
puts "Part 1: #{overclaimed}"

claims.each do |claim|
  good = true
  (claim[:x] .. (claim[:x]+claim[:w]-1)).each do |x|
    (claim[:y] .. (claim[:y]+claim[:h]-1)).each do |y|
      good = false if sheet[x+y*1000] > 1
    end
  end
  if good
    puts "Part 2: #{claim[:id]}"
    break
  end
end
