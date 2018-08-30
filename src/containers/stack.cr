require "./common"

class Stack(T)
  include Enumerable(T)

  def initialize
    @container = Deque(T).new
  end

  def self.new(ary : Array(T))
    stack = Stack(T).new
    ary.each { |e| stack << e } unless ary.empty?
    stack
  end

  def next
    @container.last
  end

  def next?
    @container.last?
  end

  def push(obj)
    @container.push(obj)
  end

  def <<(obj)
    @container.push obj
  end

  def pop
    @container.pop
  end

  def pop?
    @container.pop?
  end

  delegate size, to: @container
  delegate empty?, to: @container

  def each
    @container.reverse_each { |e| yield e }
  end
end
