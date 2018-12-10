def linked_run(max_players, max_marbles)
  circle = { val: 0, n: nil, p: nil }
  circle[:n] = circle
  circle[:p] = circle

  scores = Hash.new(0)

  linked_turn = lambda do |marble, player|
    if marble % 23 == 0
      scores[player] += marble
      7.times { circle = circle[:p] }
      scores[player] += circle[:val]
      circle[:p][:n] = circle[:n]
      circle[:n][:p] = circle[:p]
      circle = circle[:n]
    else
      2.times { circle = circle[:n] }
      new_node = { val: marble, n: circle, p: circle[:p] }
      new_node[:n][:p] = new_node
      new_node[:p][:n] = new_node
      circle = new_node
    end
  end

  # print_circle = lambda do
  #   curr = circle
  #   arr = ["(#{curr[:val]})"]
  #   loop do
  #     curr = curr[:n]
  #     break if curr == circle
  #     arr << curr[:val]
  #   end
  #   arr.join(' ')
  # end

  (1 .. max_marbles).each do |n|
    linked_turn.call(n, n % max_players)
  end

  return scores.values.max
end

puts("Part 1: #{linked_run(411, 71170)}")
puts("Part 2: #{linked_run(411, 7117000)}")
