
require "common"

class Deque(T)
  include Enumerable

  # private
  class Node
    property :next
    property :prev
    property :data

    def initialize(@data : T, @next : Node?, @prev : Node?)
    end
  end

  def initialize
    @front = @back = nil
    @size = 0
  end

  getter size
  alias_method "length", "size"

  def self.new(ary : Array(T))
    deque = Deque(T).new
    ary.each { |e| deque.push_back(e) } unless ary.empty?
    deque
  end

  def empty?
    @size == 0
  end

  def clear
    @front = @back = nil
    @size = 0
  end

  def front
    @front.try &.data
  end

  def back
    @back.try &.data
  end

  def push_front(obj)
    node = Node.new(obj, nil, nil)
    if front = @front
      front.next = node
      node.prev = @front
      @front = node
    else
      @front = @back = node
    end
    @size += 1
    obj
  end

  def push_back(obj)
    node = Node.new(obj, nil, nil)
    if back = @back
      back.next = node
      node.prev = @back
      @back = node
    else
      @front = @back = node
    end
    @size += 1
    obj
  end

  def pop_front
    front = @front
    return unless front

    data = front.data

    if @size == 1
      clear
    else
      @size -= 1
      if front = @front = front.next
        front.prev = nil
      end
    end
    data
  end

  def pop_back
    back = @back
    return unless back

    data = back.data
    
    if @size == 1
      clear
    else
      @size -= 1
      if back = @back = back.prev
        back.next = nil
      end
    end
    data
  end

  def each
    node = @front
    while node
      yield node.data as T
      node = node.next
    end
  end

  def reverse_each
    node = @back
    while node
      yield node.data as T
      node = node.prev
    end
  end

end
