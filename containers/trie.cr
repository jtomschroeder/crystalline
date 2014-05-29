
class Trie
  NIL = NilNode.new

  def initialize
    @root = NIL
  end

  def push(key : String, value : String)
    return nil if key.empty?
    @root = push_recursive(@root, key, 0, value)
    value
  end
  # alias_method :[]=, :push

  def has_key?(key : String)
    !get_recursive(@root, key, 0).nil?
  end

  def get(key : String)
    node = get_recursive(@root, key, 0) as Node
    node.nil? ? nil : node.value
  end
  # alias_method :[], :get

  def longest_prefix(string : String)
    string[0...prefix_recursive(@root, string, 0)]
  end

  def wildcard(string : String)
    return wildcard_recursive(@root, string, 0, "").sort
  end

  # private

  class Node
    property :char
    property :value
    property :left
    property :mid
    property :right
    property :end

    def initialize(@char : UInt8, @value : String)
      @left = @mid = @right = Trie::NIL
      @end = false
    end

    def last?
      @end == true
    end
  end

  class NilNode < Node
    def initialize
    end

    def nil?
      true
    end
  end

  def wildcard_recursive(node : Node, string, index, prefix)
    return [] of String if node.nil? || index == string.length

    arr = [] of String
    char = string[index]
    if (char.chr == '*' || char.chr == '.' || char < node.char)
      arr.concat wildcard_recursive(node.left, string, index, prefix)
    end
    if char.chr == '*' || char.chr == '.' || char > node.char
      arr.concat wildcard_recursive(node.right, string, index, prefix)
    end
    if (char.chr == '*' || char.chr == '.' || char == node.char)
      arr << "#{prefix}#{node.char.chr}" if node.last?
      arr.concat wildcard_recursive(node.mid, string, index + 1, prefix + node.char.chr.to_s)
    end
    arr
  end

  def prefix_recursive(node, string, index)
    return 0 if node.nil? || index == string.length
    len = 0
    rec_len = 0
    char = string[index]
    if (char < node.char)
      rec_len = prefix_recursive(node.left, string, index)
    elsif (char > node.char)
      rec_len = prefix_recursive(node.right, string, index)
    else
      len = index + 1 if node.last?
      rec_len = prefix_recursive(node.mid, string, index + 1)
    end
    len > rec_len ? len : rec_len
  end

  def push_recursive(node, string, index, value)
    char = string[index]
    node = Node.new(char, value) if node.nil?
    if (char < node.char)
      node.left = push_recursive(node.left, string, index, value)
    elsif (char > node.char)
      node.right = push_recursive(node.right, string, index, value)
    elsif (index < string.length - 1)
      node.mid = push_recursive(node.mid, string, index + 1, value)
    else
      node.end = true
      node.value = value
    end
    node
  end

  def get_recursive(node : Node, string, index)
    return Trie::NIL if node.nil?
    char = string[index]
    if (char < node.char as UInt8)
      return get_recursive(node.left as Node, string, index)
    elsif (char > node.char as UInt8)
      return get_recursive(node.right as Node, string, index)
    elsif (index < string.length - 1)
      return get_recursive(node.mid as Node, string, index + 1)
    else
      return node.last? ? node : @NIL
    end
  end
end
