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

  def get_successor(node)
    return unless node

    temp = node.right

    temp = temp.left while temp.left

    temp
  end

  def delete(value, node = @root)
    return unless node

    if value > node.value
      node.right = delete(value, node.right)
    elsif value < node.value
      node.left = delete(value, node.left)
    else
      return node.left unless node.right
      return node.right unless node.left

      succ = get_successor(node)
      node.value = succ.value
      node.right = delete(succ.value, node.right)
    end

    node
  end

  def find(value, node = @root)
    return unless node

    if value > node.value
      return find(value, node.right)
    elsif value < node.value
      return find(value, node.left)
    end

    node
  end

  def level_order
    queue = [@root]
    res = []
    until queue.empty?
      node = queue.pop
      queue.unshift(node.left) if node.left
      queue.unshift(node.right) if node.right
      yield(node) if block_given?

      res.push(node.value) unless block_given?
    end

    res unless block_given?
  end

  def level_order_priv(block, list = [@root])
    return if list.empty?

    node = list.pop
    block.call(node)

    list.unshift(node.left) if node.left
    list.unshift(node.right) if node.right

    level_order_priv(block, list)
  end

  def level_order_rec(&block)
    res = []

    if block_given?
      level_order_priv(block)
    else
      push_block = proc { |node| res.push(node.value) }
      level_order_priv(push_block)
      res
    end
  end

  def inorder_priv(block, node = @root)
    return unless node

    inorder_priv(block, node.left) if node.left
    block.call(node)
    inorder_priv(block, node.right) if node.right
  end

  def inorder(&block)
    res = []

    if block_given?
      inorder_priv(block)
    else
      push_block = proc { |node| res.push(node.value) }
      inorder_priv(push_block)
      res
    end
  end

  def preorder_priv(block, node = @root)
    return unless node

    block.call(node)
    preorder_priv(block, node.left) if node.left
    preorder_priv(block, node.right) if node.right
  end

  def preorder(&block)
    res = []

    if block_given?
      preorder_priv(block)
    else
      push_block = proc { |node| res.push(node.value) }
      preorder_priv(push_block)
      res
    end
  end

  def postorder_priv(block, node = @root)
    return unless node

    postorder_priv(block, node.left) if node.left
    postorder_priv(block, node.right) if node.right
    block.call(node)
  end

  def postorder(&block)
    res = []

    if block_given?
      postorder_priv(block)
    else
      push_block = proc { |node| res.push(node.value) }
      postorder_priv(push_block)
      res
    end
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
