require "../containers/common"

abstract class AbstractIterator(T)
  include Enumerable(T)

  class EndOfIteratorException < Exception; end

  abstract def at_end?
  abstract def at_beginning?

  def forward
    raise(EndOfIteratorException.new) if at_end?
    basic_forward
  end

  def backward
    raise(EndOfIteratorException.new) if at_beginning?
    basic_backward
  end

  def set_to_begin
    until at_beginning?
      basic_backward
    end
  end

  def set_to_end
    until at_end?
      basic_forward
    end
  end

  protected abstract def basic_forward
  protected abstract def basic_backward

  protected def basic_current
    backward; forward
  end
  protected def basic_peek
    forward; backward
  end

  def move_forward_until
    until at_end?
      element = basic_forward
      return element if yield(element)
    end
    nil
  end

  def move_backward_until
    until at_beginning?
      element = basic_backward
      return element if yield(element)
    end
    nil
  end

  def current
    at_beginning? ? self : basic_current
  end

  def peek
    at_end? ? self : basic_peek
  end

  def current_edge
    [current, peek]
  end

  def first
    set_to_begin; forward
  end

  def last
    set_to_end; backward
  end

  def empty?
    at_end? && at_beginning?
  end

  def each
    set_to_begin
    until at_end?
      yield basic_forward
    end
    self
  end
end

class CollectionIterator(T) < AbstractIterator(T)
  getter pos
  @seq : Array(T)

  def initialize(seq)
    @pos = 0
    @seq = seq.to_a
    set_to_begin
  end

  def at_end?
    @pos + 1 >= @seq.size
  end

  def at_beginning?
    @pos < 0
  end

  def set_to_begin
    @pos = -1
  end

  def set_to_end
    @pos = @seq.size - 1
  end

  def basic_forward
    @pos += 1; @seq[@pos]
  end

  def basic_backward
    r = @seq[@pos]; @pos -= 1; r
  end

  protected def basic_current
    @seq[@pos]
  end
  protected def basic_peek
    @seq[@pos + 1]
  end
end
