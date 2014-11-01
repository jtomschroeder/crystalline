
require "stack"
require "queue"

class SplayTreeMap(K, V)

  def initialize
    @root = nil
    @size = 0
    @header = Node.new(nil, nil)
  end

  getter size

  def clear
    @root = nil
    @size = 0
    @header = Node.new(nil, nil)
  end
  
  def push(key, value)
    if @root.nil?
      @root = Node.new(key, value)
      @size = 1
      return value
    end

    splay(key)

    root = @root.not_nil!

    cmp = (key <=> root.key.not_nil!)
    if cmp == 0
      root.value = value
      return value
    end
    node = Node.new(key, value)
    if cmp < 1
      node.left  = root.left
      node.right = root
      root.left  = nil
    else
      node.right = root.right
      node.left  = root
      root.right = nil
    end
    @root = node
    @size += 1
    value
  end
  alias_method "[]=", "push"

  def height
    height_recursive(@root)
  end

  def has_key?(key)
    !get(key).nil?
  end

  def get(key : K)
    return nil if @root.nil?
        
    splay(key)
    root = @root.not_nil!
    (root.key <=> key) == 0 ? root.value : nil
  end

  def [](key : K)
    get(key)
  end

  def min
    return nil if @root.nil?
    n = @root
    until n.not_nil!.left.nil?
      n = n.not_nil!.left
    end
    n = n.not_nil!
    splay(n.key)
    return [n.key, n.value]
  end

  def max
    return nil if @root.nil?
    n = @root
    until n.not_nil!.right.nil?
      n = n.not_nil!.right
    end
    n = n.not_nil!
    splay(n.key)
    return [n.key, n.value]
  end

  def delete(key)
    return nil if @root.nil?
    deleted = nil
    splay(key)
    root = @root.not_nil!
    if (key <=> root.key) == 0 # The key exists
      deleted = root.value
      if root.left.nil?
        @root = root.right
      else
        x = root.right
        @root = root.left
        splay(key)
        root = @root.not_nil!
        root.right = x
      end
    end
    deleted
  end

  # Iterates over the map in ascending order.
  # - Uses an iterative, not recursive, approach.
  def each
    return nil if @root.nil?

    stack = Stack(Node).new
    cursor = @root

    until cursor.nil?
      cursor = cursor.not_nil!
      stack.push(cursor)
      cursor = cursor.left
    end

    until stack.empty?
      cursor = stack.pop.not_nil!
      yield(cursor.key, cursor.value)
      cursor = cursor.right
    end
  end

  # private
  class Node
    property :left
    property :right

    def initialize(@key : K, @value : V, @left = nil, @right = nil)
    end

    # Enforce type of node properties (key & value)
    macro node_prop(prop, type)
      # TODO: "as {{type}}" instead of ".not_nil!"
      def {{prop}}; @{{prop}}.not_nil!; end
      def {{prop}}=(@{{prop}} : {{type}}); end
    end

    node_prop key, K
    node_prop value, V
  end

  # Moves key to the root, updating the structure in each step.
  private def splay(key : K)
    l, r = @header, @header
    t = @root.not_nil!
    @header.left, @header.right = nil, nil

    loop do
      t = t.not_nil!
      if (key <=> t.key.not_nil!) == -1
        break if t.left.nil?
        if (key <=> t.left.not_nil!.key.not_nil!) == -1
          y = t.left.not_nil!
          t.left = y.right
          y.right = t
          t = y
          break if t.left.nil?
        end
        r.left = t
        r = t
        t = t.left.not_nil!
      elsif (key <=> t.key.not_nil!) == 1
        break if t.right.nil?
        if (key <=> t.right.not_nil!.key.not_nil!) == 1
          y = t.right.not_nil!
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
    t = t.not_nil!
    l.right, r.left = t.left, t.right
    t.left, t.right = @header.right, @header.left
    @root = t
  end

  # Recursively determine height
  private def height_recursive(node : Node | Nil)
    return 0 if node.nil?

    node = node.not_nil!

    left_height  = 1 + height_recursive(node.left)
    right_height = 1 + height_recursive(node.right)

    left_height > right_height ? left_height : right_height
  end
end
