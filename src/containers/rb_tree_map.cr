require "./stack"
require "./common"

class RBTreeMap(K, V)
  # include Enumerable

  @root : Node(K, V)?

  def initialize
    @root = nil
    @height_black = 0
  end

  def push(key : K, value : V)
    @root = insert(@root, key, value)
    @height_black += 1 if isred(@root)
    if root = @root
      root.color = Color::BLACK
    end
    value
  end

  def []=(key, value)
    push(key, value)
  end

  def size
    @root.try &.size || 0
  end

  def height
    @root.try &.height || 0
  end

  def empty?
    @root.nil?
  end

  def has_key?(key : K)
    !get(key).nil?
  end

  def get(key : K)
    get_recursive(@root, key)
  end

  def [](key : K)
    get key
  end

  private def get_recursive(node : Node?, key : K)
    if node
      case key <=> node.key
      when  0 then return node.value
      when -1 then return get_recursive(node.left, key)
      when  1 then return get_recursive(node.right, key)
      end
    end
  end

  def min_key
    if root = @root
      min_recursive(root)
    end
  end

  private def min_recursive(node : Node)
    if node_left = node.left
      min_recursive(node_left)
    else
      node.key
    end
  end

  def max_key
    if root = @root
      max_recursive(root)
    end
  end

  private def max_recursive(node : Node)
    if node_right = node.right
      max_recursive(node_right)
    else
      node.key
    end
  end

  def delete(key : K)
    result = nil
    if root = @root
      @root, result = delete_recursive(root, key)
      if root = @root
        root.color = Color::BLACK
      end
    end
    result
  end

  private def delete_recursive(node : Node, key : K)
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
      if !isred(node.right) && !isred(node.right.try &.left)
        node.move_red_right
      end
      if (key <=> node.key) == 0
        result = node.value
        if node_right = node.right
          node.value = get_recursive(node_right, min_recursive(node_right)).not_nil!
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

  def delete_min
    if root = @root
      @root, result = delete_min_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
      result
    end
  end

  private def delete_min_recursive(node : Node)
    if node_left = node.left
      if !isred(node.left) && !isred(node.left.try &.left)
        node.move_red_left
      end

      if node_left = node.left
        node.left, result = delete_min_recursive(node_left)
      end

      {node.fixup, result}
    else
      {nil, node.value}
    end
  end

  def delete_max
    if root = @root
      @root, result = delete_max_recursive(root)
      if root = @root
        root.color = Color::BLACK
      end
      result
    end
  end

  private def delete_max_recursive(node : Node)
    if isred(node.left)
      node = node.rotate_right
    end
    if node
      if node_right = node.right
        if !isred(node_right) && !isred(node_right.left)
          node.move_red_right
        end

        if node_right = node.right
          node.right, result = delete_max_recursive(node_right)
        end

        return {node.fixup, result}
      else
        return {nil, node.value}
      end
    end
    {nil, nil} # FIXME: should be unreachable
  end

  private macro make_iterator(name, from, to)
    def {{name}}
      node = @root
      return unless node

      stack = Stack(Node(K, V)).new

      # In-order traversal (keys in ascending order)
      while !stack.empty? || !node.nil?
        if node
          stack.push(node)
          node = node.{{from}}
        else
          if node = stack.pop
            yield(node.key, node.value)
            node = node.{{to}}
          end
        end
      end
    end
  end

  make_iterator each, left, right
  make_iterator reverse_each, right, left

  # DEBUG
  def print_levels
    if root = @root
      root.print_levels
    end
  end

  # private
  module Color
    BLACK = 0
    RED   = 1
  end

  # private
  class Node(K, V)
    property color
    property key : K
    property value : V
    property left : Node(K, V)?
    property right : Node(K, V)?
    property size
    property height

    def initialize(@key : K, @value : V)
      @color = Color::RED
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
      left_height = @left.try &.height || 0
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
      self
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
      self
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

    # DEBUG
    def print_levels(n = [self], level = 0)
      nxt = [] of Node?
      n.each do |node|
        print(" " * (2 ** (height - level)))
        if node
          print "#{node.key}"
          nxt << node.left
          nxt << node.right
        else
          print "*"
        end
        print(" " * ((2 ** (height - level)) - 1))
      end
      puts
      unless level == height - 1
        print_levels nxt, level + 1
      end
    end
  end

  private def insert(node : Node?, key : K, value : V)
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

  private def isred(node : Node?)
    if node
      node.color == Color::RED
    else
      false
    end
  end
end
