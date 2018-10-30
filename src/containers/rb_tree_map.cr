require "./stack"
require "./common"
require "./rb_tree_set"

module Crystalline::Containers
  class RBTreeMap(K, V)
    # include Enumerable

    class Pair(K, V)
      property key : K
      property value : (V | Nil)

      def initialize(@key, @value)
      end

      def <=>(other : Pair(K, V))
        self.key <=> other.key
      end
    end

    @alt_impl : RBTreeSet(Pair(K, V))

    def initialize
      @alt_impl = RBTreeSet(Pair(K, V)).new
    end

    def push(key, value)
      @alt_impl.push(Pair(K, V).new(key, value))
    end

    def []=(key, value)
      @alt_impl.push(Pair(K, V).new(key, value))
    end

    def size
      @alt_impl.size
    end

    def height
      @alt_impl.height
    end

    def empty?
      @alt_impl.empty?
    end

    def has_key?(key : K)
      @alt_impl.has_key?(Pair(K, V).new(key, nil))
    end

    def get(key : K)
      @alt_impl.get(Pair(K, V).new(key, nil)).value
    end

    def [](key : K)
      get key
    end

    def min_key
      n = @alt_impl.min_key
      if n.nil?
        nil
      else
        n.key
      end
    end

    def max_key
      n = @alt_impl.max_key
      if n.nil?
        nil
      else
        n.key
      end
    end

    def delete(key : K)
      n = @alt_impl.delete(Pair(K, V).new(key, nil))
      if n.nil?
        nil
      else
        n.key
      end
    end

    def delete_min
      @alt_impl.delete_min
    end

    def delete_max
      @alt_impl.delete_max
    end

    private macro make_iterator(name, from, to)
	def {{name}}
			@alt_impl.{{name}} do |pair|
				yield(pair.key, pair.value)
			end
		end
	end

    make_iterator each, left, right
    make_iterator reverse_each, right, left
  end
end
