
require "deque"

class Queue(T)
  include Enumerable
  
  def initialize
    @container = Deque(T).new
  end

  def self.new(ary : Array(T))
    queue = Queue(T).new
    ary.each { |e| queue << e } unless ary.empty?
    queue
  end
   
  def next
    @container.front
  end
  
  def push(obj)
    @container.push_back(obj)
  end

  def <<(obj)
    push(obj)
  end

  def pop
    @container.pop_front
  end
  
  def size
    @container.size
  end
  
  def empty?
    @container.empty?
  end
  
  def each
    @container.each { |e| yield e }
  end
end
