require "./common"

class Trie(T)
  @root : Node(T)?

  def initialize
  end

  def push(key : String, value : T)
    unless key.empty?
      @root = push_recursive(@root, key, 0, value)
      value
    end
  end

  def []=(key, value)
    push(key, value)
  end

  private def push_recursive(node : Node?, string, index, value)
    char = string[index]
    node ||= Node(T).new(char, value)
    node_char = node.char

    if char < node_char
      node.left = push_recursive(node.left, string, index, value)
    elsif char > node_char
      node.right = push_recursive(node.right, string, index, value)
    elsif index < string.size - 1
      node.mid = push_recursive(node.mid, string, index + 1, value)
    else
      node.end = true
      node.value = value
    end

    node
  end

  def has_key?(key : String)
    !get_recursive(@root, key, 0).nil?
  end

  def get(key : String)
    get_recursive(@root, key, 0).try &.value
  end

  def [](key)
    get key
  end

  private def get_recursive(node : Node?, string, index)
    if node
      char = string[index]
      node_char = node.char

      if char < node_char
        return get_recursive(node.left, string, index)
      elsif char > node_char
        return get_recursive(node.right, string, index)
      elsif index < string.size - 1
        return get_recursive(node.mid, string, index + 1)
      else
        return node.last? ? node : nil
      end
    end
  end

  def longest_prefix(string : String)
    string[0...prefix_recursive(@root, string, 0)]
  end

  private def prefix_recursive(node : Node?, string, index)
    len = 0
    rec_len = 0
    if node && index < string.size
      char = string[index]
      node_char = node.char

      if char < node_char
        rec_len = prefix_recursive(node.left, string, index)
      elsif char > node_char
        rec_len = prefix_recursive(node.right, string, index)
      else
        len = index + 1 if node.last?
        rec_len = prefix_recursive(node.mid, string, index + 1)
      end
    end
    Math.max(len, rec_len)
  end

  def wildcard(string : String)
    wildcard_recursive(@root, string, 0, "").sort
  end

  private def wildcard_recursive(node : Node?, string, index, prefix)
    arr = [] of String
    if node && index < string.size
      char = string[index]
      node_char = node.char

      if char == '*' || char == '.' || char < node_char
        arr.concat wildcard_recursive(node.left, string, index, prefix)
      end
      if char == '*' || char == '.' || char > node_char
        arr.concat wildcard_recursive(node.right, string, index, prefix)
      end
      if char == '*' || char == '.' || char == node_char
        arr << "#{prefix}#{node.char}" if node.last?
        arr.concat wildcard_recursive(node.mid, string, index + 1, prefix + node_char.to_s)
      end
    end
    arr
  end

  # private
  class Node(T)
    property char
    property value
    property left : Node(T)?
    property mid : Node(T)?
    property right : Node(T)?
    property :end # not sure if this is a good name


    def initialize(@char : Char, @value : T)
      @end = false
    end

    def last?
      @end == true
    end
  end
end
