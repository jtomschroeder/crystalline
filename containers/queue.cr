
require "deque"
require "common"

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
  alias_method "<<", "push"

  def pop
    @container.pop_front
  end

  delegate size, @container
  delegate empty?, @container

  def each
    @container.each { |e| yield e }
  end
end
