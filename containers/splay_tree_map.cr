
require "stack"
require "queue"

class SplayTreeMap(K, V)
  def push(key, value)
    if @root.nil?
      @root = Node.new(key, value)
      @size = 1
      return value
    end

    splay(key)

    cmp = (key <=> @root.key as K)
    if cmp == 0
      @root.value = value
      return value
    end
    node = Node.new(key, value)
    if cmp < 1
      node.left = @root.left
      node.right = @root
      @root.left = Node::NIL
    else
      node.right = @root.right
      node.left = @root
      @root.right = Node::NIL
    end
    @root = node
    @size += 1
    value
  end

  def []=(key : K, value : V)
    push(key, value)
  end

  def size
    @size
  end

  def clear
    @root = Node::NIL
    @size = 0
    @header = Node.new(nil, nil)
  end

  def height
    height_recursive(@root)
  end

  def has_key?(key)
    !get(key).nil?
  end

  def get(key : K)
    return nil if @root.nil?

    splay(key)
    (@root.key as K <=> key) == 0 ? @root.value : nil
  end

  def [](key : K)
    get(key)
  end

  def min
    return nil if @root.nil?
    n = @root
    while !n.left.nil?
      n = n.left
    end
    splay(n.key as K)
    return [n.key, n.value]
  end

  def max
    return nil if @root.nil?
    n = @root
    while !n.right.nil?
      n = n.right
    end
    splay(n.key as K)
    return [n.key, n.value]
  end

  def delete(key)
    return nil if @root.nil?
    deleted = Node::NIL
    splay(key)
    if (key <=> @root.key as K) == 0 # The key exists
      deleted = @root.value
      if @root.left.nil?
        @root = @root.right
      else
        x = @root.right
        @root = @root.left
        splay(key)
        @root.right = x
      end
    end
    deleted
  end

  # Iterates over the map in ascending order.
  # - Uses an iterative, not recursive, approach.
  def each
    return nil if @root.nil?

    stack = Stack(Node).new
    cursor = @root as Node

    until cursor.nil?
      stack.push(cursor)
      cursor = cursor.left
    end

    until stack.empty?
      cursor = stack.pop as Node
      yield(cursor.key, cursor.value as V)
      cursor = cursor.right
    end
  end

  # private

  class Node
    property :key
    property :value
    property :left
    property :right

    NIL = NilNode.new

    def initialize(@key : K, @value : V, @left = NIL, @right = NIL)
    end
  end

  class NilNode < Node
    def initialize
    end

    def nil?
      true
    end
  end

  def initialize
    @root = Node::NIL
    @size = 0
    @header = Node.new(nil, nil)
  end

  # Moves key to the root, updating the structure in each step.
  def splay(key : K)
    l, r = @header, @header
    t = @root as Node
    @header.left, @header.right = Node::NIL, Node::NIL

    loop do
      if (key <=> t.key as K) == -1
        break if t.left.nil?
        if (key <=> t.left.key as K) == -1
          y = t.left
          t.left = y.right
          y.right = t
          t = y
          break if t.left.nil?
        end
        r.left = t
        r = t
        t = t.left
      elsif (key <=> t.key as K) == 1
        break if t.right.nil?
        if (key <=> t.right.key as K) == 1
          y = t.right
          t.right = y.left
          y.left = t
          t = y
          break if t.right.nil?
        end
        l.right = t
        l = t
        t = t.right
      else
        break
	    end
    end
    l.right, r.left = t.left, t.right
    t.left, t.right = @header.right, @header.left
    @root = t
  end

  # Recursively determine height
  def height_recursive(node)
    return 0 if node.nil?

    left_height  = 1 + height_recursive(node.left)
    right_height = 1 + height_recursive(node.right)

    left_height > right_height ? left_height : right_height
  end
end
