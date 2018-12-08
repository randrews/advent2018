def reacts(ch1, ch2)
  (ch2 == ch1.downcase && ch1 == ch2.upcase) || (ch1 == ch2.downcase && ch2 == ch1.upcase)
end

chain = []
File.read('day5.txt').split(//).each do |ch|
  next unless ch =~ /[a-zA-Z]/
  if chain.last && reacts(chain.last, ch)
    chain.pop
  else
    chain << ch
  end
end

puts("Part 1: #{chain.length}")

lengths = ('a'..'z').map do |unit|
  chain = []
  File.read('day5.txt').split(//).each do |ch|
    next unless ch =~ /[a-zA-Z]/
    next if ch.downcase == unit
    if chain.last && reacts(chain.last, ch)
      chain.pop
    else
      chain << ch
    end
  end
  chain.length
end

puts("Part 2: #{lengths.min}")
