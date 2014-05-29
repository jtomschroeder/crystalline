
require "stack"

class RBTreeMap(K, V)
  def initialize
    @root = NIL
    @height_black = 0
  end

  def push(key, value)
    @root = insert(@root, key, value)
    @height_black += 1 if @root.red?
    @root.color = Color::BLACK
    value
  end

  def []=(key, value)
    push(key, value)
  end

  def empty?
    @root.nil?
  end

  def size
    return 0 if @root.nil?
    @root.size
  end

  def height
    return 0 if @root.nil?
    @root.height
  end

  def has_key?(key)
    !get(key).nil?
  end

  def get(key)
    get_recursive(@root, key)
  end

  def [](key)
    get(key)
  end

  def min_value
    @root.nil? ? nil : min_recursive(@root).value
  end

  def min_key
    @root.nil? ? nil : min_recursive(@root).key
  end

  def max_value
    @root.nil? ? nil : max_recursive(@root).value
  end

  def max_key
    @root.nil? ? nil : max_recursive(@root).key
  end

  def delete(key)
    unless @root.nil?
      @root = delete_recursive(@root, key)
      @root.color = Color::BLACK unless @root.nil?
    end
  end

  def delete_min
    unless @root.nil?
      @root = delete_min_recursive(@root)
      @root.color = Color::BLACK unless @root.nil?
    end
  end

  def delete_max
    unless @root.nil?
      @root = delete_max_recursive(@root)
      @root.color = Color::BLACK unless @root.nil?
    end
  end

  def each
    return nil if @root.nil?

    stack = Stack(Node).new
    node = @root as Node

    # In-order traversal (keys ascending order)
    while !stack.empty? || !node.nil?
      unless node.nil?
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

  NIL = NilNode.new
  
  module Color
    BLACK = 0
    RED = 1
  end

  class Node
    property :color
    property :key
    property :value
    property :left
    property :right
    property :size
    property :height

    def initialize(@key : V, @value : V, @left = RBTreeMap::NIL, @right = RBTreeMap::NIL)
      @color = Color::RED
      @size = 1
      @height = 1
    end

    def red?
      @color == Color::RED
    end

    def colorflip
      @color       = self.red?   ? Color::BLACK : Color::RED
      @left.color  = @left.red?  ? Color::BLACK : Color::RED
      @right.color = @right.red? ? Color::BLACK : Color::RED
    end

    def update_size
      @size = (!@left.nil? ? @left.size : 0) + (!@right.nil? ? @right.size : 0) + 1
      left_height  = (!@left.nil? ? @left.height : 0)
      right_height = (!@right.nil? ? @right.height : 0)
      @height = left_height > right_height ? left_height + 1 : right_height + 1
      self
    end

    def rotate_left
      r = @right
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

    def rotate_right
      l = @left
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

    def move_red_left
      colorflip
      if (!@right.left.nil? && @right.left.red?)
        @right.rotate_right
        rotate_left
        colorflip
      end
      self
    end

    def move_red_right
      colorflip
      if (!@left.left.nil? && @left.left.red?)
        rotate_right
        colorflip
      end
      self
    end

    def fixup
      rotate_left if !@right.nil? && @right.red?
      rotate_right if (!@left.nil? && @left.red?) && (!@left.left.nil? && @left.left.red?)
      colorflip if (!@left.nil? && @left.red?) && (!@right.nil? && @right.red?)

      update_size
    end
  end

  class NilNode < Node
    def initialize
    end

    def nil?
      true
    end

    def red?
      false
    end
  end

  def delete_recursive(node : Node, key : K)
    if (key <=> node.key) == -1
      node.move_red_left if !node.left.red? && !node.left.left.red?
      node.left = delete_recursive(node.left, key)
    else
      node.rotate_right if node.left.red?
      if ((key <=> node.key) == 0) && node.right.nil?
        return NIL
      end
      if !node.right.red? && !node.right.left.red?
        node.move_red_right
      end
      if (key <=> node.key) == 0
        node.value = get_recursive(node.right, min_recursive(node.right).key)
        node.key   = min_recursive(node.right).key
        node.right = delete_min_recursive(node.right)
      else
        node.right = delete_recursive(node.right, key)
      end
    end
    return node.fixup
  end

  def delete_min_recursive(node)
    if node.left.nil?
      return NIL
    end
    if !node.left.red? && !node.left.left.red?
      node.move_red_left
    end
    node.left = delete_min_recursive(node.left)

    return node.fixup
  end

  def delete_max_recursive(node)
    if node.left.red?
      node = node.rotate_right
    end
    return NIL if node.right.nil?
    if !node.right.red? && !node.right.left.red?
      node.move_red_right
    end
    node.right = delete_max_recursive(node.right)

    return node.fixup
  end

  def get_recursive(node, key)
    return nil if node.nil?
    case key <=> node.key
    when  0 then return node.value
    when -1 then return get_recursive(node.left, key)
    when  1 then return get_recursive(node.right, key)
    end
  end

  def min_recursive(node)
    return node if node.left.nil?

    min_recursive(node.left)
  end

  def max_recursive(node)
    return node if node.right.nil?

    max_recursive(node.right)
  end

  def insert(node, key, value)
    return Node.new(key, value) if node.nil?

    case key <=> node.key
    when  0 then node.value = value
    when -1 then node.left  = insert(node.left, key, value)
    when  1 then node.right = insert(node.right, key, value)
    end

    node.rotate_left if (!node.right.nil? && node.right.red?)
    node.rotate_right if (!node.left.nil? && node.left.red? && !node.left.left.nil? && node.left.left.red?)
    node.colorflip if (!node.left.nil? && node.left.red? && !node.right.nil? && node.right.red?)
    node.update_size
  end
end
