
require "common"

class Deque(T)
  include Enumerable

  # private
  class Node
    property :next
    property :prev
    property :data

    def initialize(@data : T, @next : Node | Nil, @prev : Node | Nil)
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

    if @size == 1
      data = front.data
      clear
      return data
    else
      @size -= 1
      data = front.data
      @front = front.next
      @front.not_nil!.prev = nil
      return data
    end
  end

  def pop_back
    back = @back
    return unless back

    if @size == 1
      data = back.data
      clear
      return data
    else
      @size -= 1
      data = back.data
      @back = back.prev
      @back.not_nil!.next = nil
      return data
    end
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
