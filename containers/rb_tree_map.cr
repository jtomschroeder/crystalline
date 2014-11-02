
require "stack"
require "common"

class RBTreeMap(K, V)
  # include Enumerable

  def initialize
    @root :: Node | Nil
    @root = nil
    @height_black = 0
  end

  def push(key, value)
    @root = insert(@root, key, value)
    @height_black += 1 if isred(@root)
    if root = @root
      root.color = Color::BLACK
    end
    value
  end
  alias_method "[]=", "push"

  def size
    @root.try &.size || 0
  end

  def height
    @root.try &.height || 0
  end

  def has_key?(key)
    !get(key).nil?
  end

  def get(key)
    get_recursive(@root, key)
  end
  alias_method "[]", "get"

  def min_key
    if root = @root
      min_recursive(root)
    end
  end

  def max_key
    if root = @root
      max_recursive(root)
    end
  end

  def delete(key)
    result = nil
    if root = @root
      @root, result = delete_recursive(root, key)
      if root = @root
        root.color = Color::BLACK
      end
    end
    result
  end

  def empty?
    @root.nil?
  end

  def delete_min
    result = nil
    if root = @root
      @root, result = delete_min_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
    end
    result
  end

  def delete_max
    result = nil
    if root = @root
      @root, result = delete_max_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
    end
    result
  end

  def each
    node = @root
    return unless node

    stack = Stack(Node).new

    # In-order traversal (keys in ascending order)
    while !stack.empty? || !node.nil?
      if node
        stack.push(node)
        node = node.left
      else
        if node = stack.pop
          yield(node.key, node.value)
          node = node.right
        end
      end
    end
  end

  def to_s
    s = "{ "
    each do |k, v| 
      s += "#{k} : #{v}"
      s += ", " if k != max_key
    end
    s += " }"
    s
  end

  def keys
    ks = [] of K
    each { |k, v| ks << k }
    ks
  end

  # private
  module Color
    BLACK = 0
    RED = 1
  end

  # private
  class Node
    property :color, :key, :value, :left, :right, :size, :height
    def initialize(@key, @value)
      @color = Color::RED

      @left :: Node | Nil
      @left = nil

      @right :: Node | Nil
      @right = nil

      @size = 1
      @height = 1
    end

    def red?
      @color == Color::RED
    end

    def colorflip
      @color = @color == Color::RED ? Color::BLACK : Color::RED
      if left = @left
        left.color = left.color == Color::RED ? Color::BLACK : Color::RED
      end
      if right = @right
        right.color = right.color == Color::RED ? Color::BLACK : Color::RED
      end
    end

    def update_size
      @size = (@left.try &.size || 0) + (@right.try &.size || 0) + 1
      left_height  = @left.try &.height || 0
      right_height = @right.try &.height || 0
      if left_height > right_height
        @height = left_height + 1
      else
        @height = right_height + 1
      end
      self
    end

    def rotate_left
      if r = @right
        r_key, r_value, r_color = r.key, r.value, r.color
        b = r.left
        r.left = @left
        @left = r
        @right = r.right
        r.right = b
        r.color, r.key, r.value = Color::RED, @key, @value
        @key, @value = r_key, r_value
        r.update_size
        update_size
      end
    end

    def rotate_right
      if l = @left
        l_key, l_value, l_color = l.key, l.value, l.color
        b = l.right
        l.right = @right
        @right = l
        @left = l.left
        l.left = b
        l.color, l.key, l.value = Color::RED, @key, @value
        @key, @value = l_key, l_value
        l.update_size
        update_size
      end
    end

    def move_red_left
      colorflip
      if right = @right
        if right.left.try &.red?
          right.rotate_right
          rotate_left
          colorflip
        end
      end
      self
    end

    def move_red_right
      colorflip
      if @left.try &.left.try &.red?
        rotate_right
        colorflip
      end
      self
    end

    def fixup
      rotate_left if @right.try &.red?
      rotate_right if @left.try &.red? && @left.try &.left.try &.red?
      colorflip if @left.try &.red? && @right.try &.red?

      update_size
    end
  end

  private def delete_recursive(node : Node, key)
    if (key <=> node.key) == -1
      node.move_red_left if !isred(node.left) && !isred(node.left.try &.left)
      if node_left = node.left
        node.left, result = delete_recursive(node_left, key)
      end
    else
      node.rotate_right if isred(node.left)
      if !node.right && (key <=> node.key) == 0
        return {nil, node.value}
      end
      if !isred(node.right) && !isred(node.right.not_nil!.left)
        node.move_red_right
      end
      if (key <=> node.key) == 0
        result = node.value
        if node_right = node.right
          node.value = get_recursive(node_right, min_recursive(node_right))
          node.key = min_recursive(node_right)
          node.right = delete_min_recursive(node_right)[0]
        end
      else
        if node_right = node.right
          node.right, result = delete_recursive(node_right, key)
        end
      end
    end
    {node.fixup, result}
  end

  private def delete_min_recursive(node : Node)
    if node_left = node.left
      if !isred(node.left) && !isred(node.left.not_nil!.left)
        node.move_red_left
      end
      node.left, result = delete_min_recursive(node_left)

      {node.fixup, result}
    else
      {nil, node.value}
    end
  end

  private def delete_max_recursive(node : Node)
    if isred(node.left)
      node = node.rotate_right
    end
    if node
      if node_right = node.right
        if ( !isred(node_right) && !isred(node_right.left) )
          node.move_red_right
        end
        node.right, result = delete_max_recursive(node_right)

        return {node.fixup, result}
      else
        return {nil, node.value}
      end
    end
    {nil, nil} # FIXME: should be unreachable
  end

  private def get_recursive(node, key)
    if node
      case key <=> node.key
        when  0 then return node.value
        when -1 then return get_recursive(node.left, key)
        when  1 then return get_recursive(node.right, key)
      end
    end
  end

  private def min_recursive(node : Node)
    if node_left = node.left
      min_recursive(node_left)
    else
      node.key
    end
  end

  private def max_recursive(node : Node)
    if node_right = node.right
      max_recursive(node_right)
    else
      node.key
    end
  end

  private def insert(node : Node?, key, value)
    if node
      case key <=> node.key
        when  0 then node.value = value
        when -1 then node.left = insert(node.left, key, value)
        when  1 then node.right = insert(node.right, key, value)
      end

      node.rotate_left if node.right.try &.red?
      node.rotate_right if node.left.try &.red? && node.left.try &.left.try &.red?
      node.colorflip if node.left.try &.red? && node.right.try &.red?
      node.update_size
    else
      Node.new(key, value)
    end
  end

  private def isred(node)
    if node
      node.color == Color::RED
    else
      false
    end
  end
end
