require 'rubocop'
require 'rubocop-performance'
require_relative 'lib/tree'

arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)

puts tree
puts tree.balanced?

p tree.level_order
p tree.level_order_rec
p tree.preorder
p tree.postorder
p tree.inorder

new_arr = (Array.new(5) { rand(100..120) })
new_arr.each { |i| tree.insert(i) }

puts tree
puts tree.balanced?

puts tree.rebalance

puts tree
puts tree.balanced?

p tree.level_order
p tree.level_order_rec
p tree.preorder
p tree.postorder
p tree.inorder
