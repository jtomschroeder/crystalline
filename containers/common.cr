
class Array(T)
  include Comparable(Array)
  
  def <=>(other)
    if size == other.size
      each_with_index { |e, i| n = e <=> other[i]; return n if n != 0 }
    end
    size <=> other.size
  end

  alias_method :add, :push
end

class Hash(K, V)
  alias_method :size, :length
end

module Enumerable(T)
  alias_method :entries, :to_a
end
