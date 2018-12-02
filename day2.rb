# Part 1:
two_count = 0
three_count = 0

File.open('day2.txt').each do |line|
  chars = {}
  line.split(//).each do |ch|
    chars[ch] ||= 0
    chars[ch] += 1
  end

  two_count += 1 if chars.values.include?(2)
  three_count += 1 if chars.values.include?(3)
end

puts "Part 1: #{two_count * three_count}"

# Part 2:

boxes = []
File.open('day2.txt').each do |line|
  boxes << line.strip
end

(0 .. (boxes[0].size-1)).each do |i|
  found = {}
  boxes.each do |box|
    box_arr = box.split(//)
    box_arr.delete_at(i)
    if found[box_arr.join]
      puts "Part 2: #{box_arr.join}"
      exit(0)
    else
      found[box_arr.join] = true
    end
  end
end
