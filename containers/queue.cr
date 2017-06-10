require "./deque"
require "./common"

class Queue(T)
  include Enumerable(T)

  def initialize
    @container = Deque(T).new
  end

  def self.new(ary : Array(T))
    queue = Queue(T).new
    ary.each { |e| queue << e } unless ary.empty?
    queue
  end

  def next
    @container.first
  end

  def next?
    @container.first?
  end

  def push(obj)
    @container.push(obj)
  end

  def <<(obj)
    push obj
  end

  def pop
    @container.shift
  end

  def pop?
    @container.shift?
  end

  delegate size, to: @container
  delegate empty?, to: @container

  def each
    @container.each { |e| yield e }
  end
end
