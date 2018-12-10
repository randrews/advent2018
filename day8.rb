nums = File.read('day8.txt').split(/\s+/).map(&:to_i)

def parse_node(arr, idx)
  child_count = arr[idx]
  meta_count = arr[idx+1]
  children = []

  curr_idx = idx + 2
  child_count.times do
    (child_node, curr_idx) = parse_node(arr, curr_idx)
    children << child_node
  end

  metas = []
  meta_count.times {|n| metas << arr[curr_idx+n] }
  [ { children: children, metas: metas }, curr_idx+meta_count ]
end

root = parse_node(nums, 0)[0]

def total_metas(node)
  sum = node[:metas].inject(&:+)
  node[:children].each {|n| sum += total_metas(n) }
  sum
end

puts("Part 1: #{total_metas(root)}")

def node_value(node)
  if node[:children].empty?
    node[:metas].inject(&:+)
  else
    sum = 0
    node[:metas].each {|m| sum += (node_value(node[:children][m-1]) rescue 0) }
    sum
  end
end

puts("Part 2: #{node_value(root)}")
