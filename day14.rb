skip = 704321
recipes = [3, 7] + [nil] * (skip + 10)
len = 2
pos1 = 0
pos2 = 1

loop do
  total = recipes[pos1] + recipes[pos2]
  if total >= 10
    recipes[len] = total / 10
    recipes[len+1] = total % 10
    len += 2
  else
    recipes[len] = total
    len += 1
  end
  pos1 += (1 + recipes[pos1]); pos1 = pos1 % len
  pos2 += (1 + recipes[pos2]); pos2 = pos2 % len
  break if len >= skip + 10
end

puts("Part 1: #{recipes[skip .. (skip+10)].join}")

# Part 2:
index = nil
loop do
  recipes += [nil] * 1000000

  loop do
    total = recipes[pos1] + recipes[pos2]
    if total >= 10
      recipes[len] = total / 10
      recipes[len+1] = total % 10
      len += 2
    else
      recipes[len] = total
      len += 1
    end
    pos1 += (1 + recipes[pos1]); pos1 = pos1 % len
    pos2 += (1 + recipes[pos2]); pos2 = pos2 % len
    break if len + 2 >= recipes.length
  end

  index = recipes.join.index('704321')
  break if index
end


puts("Part 2: #{index}")
