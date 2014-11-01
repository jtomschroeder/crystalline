
require "deque"
require "common"

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
  alias_method "<<", "push"
  
  def pop
    @container.pop_back as (T | Nil)
  end

  delegate size, @container
  delegate empty?, @container
  
  def each
    @container.reverse_each { |e| yield e }
  end
end
