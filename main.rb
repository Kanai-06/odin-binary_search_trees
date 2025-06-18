require 'rubocop'
require 'rubocop-performance'
require_relative 'lib/tree'

a = (Array.new(15) { rand(1..100) })
t = Tree.new(a)
puts t
t.insert(18)
puts
puts t
