
require "common"

class Trie

  def initialize
    @root = nil
  end

  def push(key : String, value : String)
    return nil if key.empty?
    @root = push_recursive(@root, key, 0, value)
    value
  end
  alias_method "[]=", "push"

  def has_key?(key : String)
    !get_recursive(@root, key, 0).nil?
  end

  def get(key : String)
    get_recursive(@root, key, 0).try &.value
  end
  alias_method "[]", "get"

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

    def initialize(@char : Char, @value : String)
      @left = @mid = @right = nil
      @end = false
    end

    def last?
      @end == true
    end
  end

  private def wildcard_recursive(node : Node | Nil, string, index, prefix)
    return [] of String if node.nil? || index == string.length

    node = node.not_nil!
    arr = [] of String
    char = string[index]
    node_char = node.char

    if (char == '*' || char == '.' || char < node_char)
      arr.concat wildcard_recursive(node.left, string, index, prefix)
    end
    if char == '*' || char == '.' || char > node_char
      arr.concat wildcard_recursive(node.right, string, index, prefix)
    end
    if (char == '*' || char == '.' || char == node_char)
      arr << "#{prefix}#{node.char}" if node.last?
      arr.concat wildcard_recursive(node.mid, string, index + 1, prefix + node_char.to_s)
    end

    arr
  end

  private def prefix_recursive(node : Node | Nil, string, index)
    return 0 if node.nil? || index == string.length

    node = node.not_nil!
    len = 0
    rec_len = 0
    char = string[index]
    node_char = node.char

    if (char < node_char)
      rec_len = prefix_recursive(node.left, string, index)
    elsif (char > node_char)
      rec_len = prefix_recursive(node.right, string, index)
    else
      len = index + 1 if node.last?
      rec_len = prefix_recursive(node.mid, string, index + 1)
    end
    len > rec_len ? len : rec_len
  end

  private def push_recursive(node : Node | Nil, string, index, value)
    char = string[index]
    node ||= Node.new(char, value)
    node_char = node.char

    if (char < node_char)
      node.left = push_recursive(node.left, string, index, value)
    elsif (char > node_char)
      node.right = push_recursive(node.right, string, index, value)
    elsif (index < string.length - 1)
      node.mid = push_recursive(node.mid, string, index + 1, value)
    else
      node.end = true
      node.value = value
    end
    
    node
  end

  private def get_recursive(node : Node | Nil, string, index)
    return unless node

    char = string[index]
    node_char = node.char

    if (char < node_char)
      return get_recursive(node.left, string, index)
    elsif (char > node_char)
      return get_recursive(node.right, string, index)
    elsif (index < string.length - 1)
      return get_recursive(node.mid, string, index + 1)
    else
      return node.last? ? node : nil
    end
  end
end
