require 'rubocop'
require 'rubocop-performance'
require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(arr = [])
    @root = build_tree(arr)
  end

  def build_tree(arr, sorted = false) # rubocop:disable Style/OptionalBooleanParameter,Metrics/AbcSize,Metrics/MethodLength
    if arr.length > 1
      new_arr = sorted ? arr : arr.sort.uniq
      mid = new_arr.length / 2

      node = Node.new(new_arr[mid])
      node.left = build_tree(new_arr[..(mid - 1)], true)
      node.right = build_tree(new_arr[(mid + 1)..], true)

      return node
    elsif arr.length == 1
      node = Node.new(arr[0])

      return node
    end

    nil
  end

  def insert(value, node = @root)
    if !node
      return Node.new(value)
    elsif value > node.value
      node.right = insert(value, node.right)
    elsif value < node.value
      node.left = insert(value, node.left)
    end

    node
  end

  def to_s(node = @root, prefix = '', is_left = true)
    res = if node.right
            "#{to_s(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false)}\n"
          else
            ''
          end
    res += "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}\n"
    res += if node.left
             "#{to_s(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true)}\n"
           else
             ''
           end

    res
  end
end
