
require "./heap"

class PriorityQueue(T)
  # include Enumerable(T)
  
  alias Priority = Int32

  def initialize(comparator = ->(x : Priority, y : Priority) { (x <=> y) == 1 })
    @heap = Heap(Priority, T).new(comparator)
  end

  def size
    @heap.size
  end
  alias_method :length, :size

  def push(object : T, priority : Priority)
    @heap.push(priority, object)
  end

  def clear
    @heap.clear
  end

  def empty?
    @heap.empty?
  end

  def has_priority?(priority : Priority)
    @heap.has_key?(priority)
  end

  def next
    @heap.next
  end

  def pop
    @heap.pop
  end
  alias_method :next!, :pop

  def delete(priority : Priority)
    @heap.delete(priority)
  end

end
