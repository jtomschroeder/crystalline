
require "deque"

class Stack(T)
  include Enumerable
  
  def initialize
    @container = Deque(T).new
  end
  
  def self.new(ary : Array(T))
    stack = Stack(T).new
    ary.each { |e| stack << e } unless ary.empty?
    stack
  end

  def next
    @container.back
  end
  
  def push(obj)
    @container.push_back(obj)
  end

  def <<(obj)
    push(obj)
  end
  
  def pop
    @container.pop_back
  end
  
  def size
    @container.size
  end
  
  def empty?
    @container.empty?
  end
  
  def each
    @container.reverse_each { |e| yield e }
  end
end
