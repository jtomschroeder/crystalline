
class Deque(T)
  include Enumerable

  class Node
    property :next
    property :prev
    property :data

    def initialize(@data : T, @next : Node, @prev : Node)
    end

    def nil?
      false
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
    @NIL = NilNode.new

    @front = @back = @NIL
    @size = 0
  end

  def self.new(ary : Array(T))
    deque = Deque(T).new
    ary.each { |e| deque.push_back(e) } unless ary.empty?
    deque
  end

  def empty?
    @size == 0
  end

  def clear
    @front = @back = @NIL
    @size = 0
  end

  def size
    @size
  end

  def length
    @size
  end

  def front
    return @front.data unless @front.nil?
    return nil
  end

  def back
    return @back.data unless @back.nil?
    return nil
  end

  def push_front(obj)
    node = Node.new(obj, @NIL, @NIL)
    unless @front.nil?
      @front.next = node
      node.prev = @front
      @front = node
    else
      @front = @back = node
    end
    @size += 1
    obj
  end

  def push_back(obj)
    node = Node.new(obj, @NIL, @NIL)
    unless @back.nil?
      @back.next = node
      node.prev = @back
      @back = node
    else
      @front = @back = node
    end
    @size += 1
    obj
  end

  def pop_front
    return nil if @front.nil?
    if @size == 1
      data = @front.data
      clear
      return data
    else
      @size -= 1
      data = @front.data
      @front = @front.next
      @front.prev = @NIL
      return data
    end
  end

  def pop_back
    return nil if @back.nil?
    if @size == 1
      data = @back.data
      clear
      return data
    else
      @size -= 1
      data = @back.data
      @back = @back.prev
      @back.next = @NIL
      return data
    end
  end

  def each
    node = @front
    until node.nil?
      yield node.data as T
      node = node.next
    end
  end

  def reverse_each
    node = @back
    until node.nil?
      yield node.data as T
      node = node.prev
    end
  end
end
