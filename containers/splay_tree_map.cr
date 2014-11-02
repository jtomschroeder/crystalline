
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
    unless @root
      @root = Node.new(key, value)
      @size = 1
      return value
    end

    splay(key)

    if root = @root
      cmp = key <=> root.key
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
    end

    @root = node
    @size += 1
    value
  end
  alias_method "[]=", "push"

  def height
    height_recursive(@root)
  end

  # Recursively determine height
  private def height_recursive(node : Node?)
    if node
      left_height  = 1 + height_recursive(node.left)
      right_height = 1 + height_recursive(node.right)

      left_height > right_height ? left_height : right_height
    else
      0
    end
  end

  def has_key?(key)
    !get(key).nil?
  end

  def get(key : K)
    return unless @root
        
    splay(key)
    if root = @root
      (root.key <=> key) == 0 ? root.value : nil
    end
  end
  alias_method "[]", "get"

  def min
    return unless @root
    
    n = @root
    while n && n.left
      n = n.left
    end

    if n
      splay(n.key)
      [n.key, n.value]
    end
  end

  def max
    return unless @root
    
    n = @root
    while n && n.right
      n = n.right
    end

    if n
      splay(n.key)
      [n.key, n.value]
    end
  end

  def delete(key)
    deleted = nil
    if root = @root
      splay(key)
      if (key <=> root.key) == 0 # The key exists
        deleted = root.value
        if root.left.nil?
          @root = root.right
        else
          x = root.right
          @root = root.left
          splay(key)
          root.right = x
        end
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

    while cursor
      stack.push(cursor)
      cursor = cursor.left
    end

    until stack.empty?
      if cursor = stack.pop
        yield(cursor.key, cursor.value)
        cursor = cursor.right
      end
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
    t = @root
    @header.left, @header.right = nil, nil

    loop do
      if t
        if (key <=> t.key.not_nil!) == -1
          break unless t.left
          if (key <=> t.left.not_nil!.key.not_nil!) == -1
            y = t.left.not_nil!
            t.left = y.right
            y.right = t
            t = y
            break unless t.left
          end
          r.left = t
          r = t
          t = t.left
        elsif (key <=> t.key.not_nil!) == 1
          break unless t.right
          if (key <=> t.right.not_nil!.key.not_nil!) == 1
            y = t.right.not_nil!
            t.right = y.left
            y.left = t
            t = y
            break unless t.right
          end
          l.right = t
          l = t
          t = t.right
        else
          break
        end
      else
        break
      end
    end

    if t
      l.right, r.left = t.left, t.right
      t.left, t.right = @header.right, @header.left
      @root = t
    end
  end

end
