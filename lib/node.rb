require 'rubocop'
require 'rubocop-performance'

class Node
  attr_accessor :value, :right, :left

  include Comparable

  def <=>(other)
    @value <=> other.value
  end

  def initialize(value = 0)
    @value = value
    @right = nil
    @left = nil
  end
end
