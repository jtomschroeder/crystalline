
require "stack"
require "common"

class RBTreeMap(K, V)

  def initialize
    @root = nil
    @height_black = 0
  end

  def push(key, value)
    @root = insert(@root, key, value)
    if root = @root
      @height_black += 1 if root.red?
      root.color = Color::BLACK
    end
    value
  end
  alias_method "[]=", "push"

  def empty?
    @root.nil?
  end

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

  def min_value
    root = @root
    return unless root
    min_recursive(root).value
  end

  def min_key
    root = @root
    return unless root
    min_recursive(root).key
  end

  def max_value
    root = @root
    return unless root
    max_recursive(root).value
  end

  def max_key
    root = @root
    return unless root
    max_recursive(root).key
  end

  def delete(key : K)
    if root = @root
      @root = delete_recursive(root, key)
      if root = @root
        root.color = Color::BLACK
      end
    end
  end

  def delete_min
    if root = @root
      @root = delete_min_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
    end
  end

  def delete_max
    if root = @root
      @root = delete_max_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
    end
  end

  def each
    node = @root
    return unless node

    stack = Stack(Node).new
    
    # In-order traversal (keys ascending order)
    while !stack.empty? || !node.nil?
      if node
        stack.push(node)
        node = node.left
      else
        node = stack.pop as Node
        yield(node.key, node.value as V)
        node = node.right
      end
    end
  end

  # private
  module Color
    BLACK = 0
    RED = 1
  end

  # private
  class Node
    property :color
    property :key
    property :value
    property :left
    property :right
    property :size
    property :height

    def initialize(@key : V, @value : V, @left = nil, @right = nil)
      @color = Color::RED
      @size = 1
      @height = 1
    end

    def red?
      @color == Color::RED
    end

    def colorflip
      @color = self.red? ? Color::BLACK : Color::RED
      if left = @left
        left.color = left.red? ? Color::BLACK : Color::RED
      end
      if right = @right
        right.color = right.red? ? Color::BLACK : Color::RED
      end
    end

    def update_size
      @size = (@left.try &.size || 0) + (@right.try &.size || 0) + 1
      left_height  = @left.try &.height || 0
      right_height = @right.try &.height || 0
      @height = left_height > right_height ? left_height + 1 : right_height + 1
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

  private def delete_recursive(node : Node, key : K)
    if node_key = node.key
      if (key <=> node_key) == -1
        if node_left = node.left
          node.move_red_left if !node_left.red? && !node_left.left.try &.red?
          node.left = delete_recursive(node_left, key)
        end
      else
        node.rotate_right if node.left.try &.red?
        if node_key = node.key
          if node.right && (key <=> node_key) == 0
            return nil
          end
          if node_right = node.right
            if !node_right.red? && !node_right.left.try &.red?
              node.move_red_right
            end
            if (key <=> node_key) == 0
              rkey = min_recursive(node_right).key
              node.value = get_recursive(node_right, rkey)
              node.key   = min_recursive(node_right).key
              node.right = delete_min_recursive(node_right)
            else
              node.right = delete_recursive(node_right, key)
            end
          end
        end
      end
    end
    node.fixup
  end

  private def delete_min_recursive(node : Node)
    node_left = node.left
    return unless node_left

    if !node_left.red? && !node_left.left.try &.red?
      node.move_red_left
    end
    node.left = delete_min_recursive(node_left)

    node.fixup
  end

  def delete_max_recursive(node : Node)
    if node.left.try &.red?
      node = node.rotate_right
    end

    if node && (node_right = node.right)
      if !node_right.red? && !node_right.left.try &.red?
        node.move_red_right
      end
      node.right = delete_max_recursive(node_right)

      node.fixup
    end
  end

  private def get_recursive(node, key : K)
    if node && (node_key = node.key)
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
      node
    end
  end

  private def max_recursive(node : Node)
    if node_right = node.right
      max_recursive(node_right)
    else
      node
    end
  end

  private def insert(node, key, value)
    return Node.new(key, value) unless node

    if node_key = node.key
      case key <=> node_key
      when  0 then node.value = value
      when -1 then node.left  = insert(node.left, key, value)
      when  1 then node.right = insert(node.right, key, value)
      end

      node.rotate_left if node.right.try &.red?
      node.rotate_right if node.left.try &.red? && node.left.try &.left.try &.red?
      node.colorflip if node.left.try &.red? && node.right.try &.red?
      node.update_size
    end
  end
end
