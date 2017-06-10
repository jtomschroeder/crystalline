
class Heap(K, V)

  def size
    @size
  end

  @next : Node(K, V)?
  @comparator : Proc(K, K, Bool)
  def initialize(@comparator = ->(x : K, y : K) { (x <=> y) == -1 })
    @size = 0
    @stored = {} of K? => Array(Node(K, V))
  end

  def push(key : K, value = key)
    node = Node(K, V).new(key, value)
    # Add new node to the left of the @next node
    if nxt = @next
      node.right = nxt
      node.left = nxt.left
      node.left.not_nil!.right = node
      nxt.left = node
      if nxt.key.nil? || @comparator.call(key, nxt.key.not_nil!)
        @next = node
      end
    else
      @next = node
    end
    @size += 1

    arr = [] of V
    if nxt = @next
      w = nxt.right
      until w == @next
        if w
          arr << w.value
          w = w.right
        end
      end
      arr << nxt.value
    end

    @stored[key] ||= [] of Node(K, V)
    @stored[key] << node
    value
  end

  def <<(key : K)
    push(key)
  end

  def has_key?(key)
    @stored.has_key?(key) && !@stored[key].empty?
  end

  def next
    @next.try &.value
  end

  def next_key
    @next.try &.key
  end

  def clear
    @next = nil
    @size = 0
    @stored = {} of K? => Array(Node(K, V))
    nil
  end

  def empty?
    @next.nil?
  end

  protected getter stored
  protected def next_node
    @next
  end

  protected def compare(x, y)
    x.nil? || y.nil? || @comparator.call(x.not_nil!, y.not_nil!)
  end

  def merge!(other_heap : Heap(K, V))
    if other_root = other_heap.next_node

      # merge @stored hash's
      other_heap.stored.each do |key, value|
        if @stored.has_key? key
          @stored[key] += value
        else
          @stored[key] = value
        end
      end

      # Insert othernode's @next node to the left of current @next
      if nxt = @next
        nxt.left.not_nil!.right = other_root
        if ol = other_root.left
          other_root.left = nxt.left
          ol.right = nxt
          nxt.left = ol
        end

        @next = other_root if compare(other_root.key, nxt.key)
      end
    end
    @size += other_heap.size
  end

  def pop
    if popped = @next
      if @size == 1
        clear
        return popped.value
      end
    else
      return
    end

    # Merge the popped's children into root node
    if nxt = @next
      if child = nxt.child
        child.parent = nil

        # get rid of parent
        sibling = child.right
        until sibling == nxt.child
          if sibling
            sibling.parent = nil
            sibling = sibling.right
          end
        end

        # Merge the children into the root. If @next is the only root node, make its child the @next node
        if nxt.right == nxt
          @next = nxt.child
        else
          next_left, next_right = nxt.left, nxt.right
          if current_child = nxt.child
            nxt.right.not_nil!.left = current_child
            nxt.left.not_nil!.right = current_child.right
            current_child.right.not_nil!.left = next_left
            current_child.right = next_right
          end
          @next = nxt.right
        end
      else
        nxt.left.not_nil!.right = nxt.right
        nxt.right.not_nil!.left = nxt.left
        @next = nxt.right
      end
    end
    consolidate

    unless @stored[popped.key].delete(popped)
      raise "Couldn't delete node from stored nodes hash"
    end
    @size -= 1

    popped.value
  end

  def change_key(key : K, new_key : K)
    return if @stored[key].nil? || @stored[key].empty? || (key == new_key)

    # Must maintain heap property
    raise "Changing this key would not maintain heap property!" unless compare(new_key, key)
    if node = @stored[key].shift
      node.key = new_key
      @stored[new_key] ||= [] of Node(K, V)
      @stored[new_key] << node
      if parent = node.parent
        # if heap property is violated
        if compare(new_key, parent.key)
          cut(node, parent)
          cascading_cut(parent)
        end
      end
      if nxt = @next
        if compare(node.key, nxt.key)
          @next = node
        end
      end
      return [node.key, node.value]
    end
    nil
  end

  def delete_key(key)
    return if !@stored.has_key?(key) || @stored[key].empty?

    if node = @stored[key].shift
      node.key = nil
      @stored[nil] = [node] of Node(K, V)
      parent = node.parent
      if parent
        cut(node, parent)
        cascading_cut(parent)
      end
      @next = node
      return [nil, node.value]
    end
    nil
  end

  def delete(key)
    pop if delete_key(key)
  end

  # private
  class Node(K, V)
    property parent : Node(K, V)?
    property child : Node(K, V)?
    property left : Node(K, V)?
    property right : Node(K, V)?
    property key
    property value
    property degree
    property marked

    def initialize(@key : K?, @value : V)
      @degree = 0
      @marked = false
      @right = self
      @left = self
    end

    def marked?
      @marked == true
    end

  end

  # make node a child of a parent node
  private def link_nodes(child, parent)
    # link the child's siblings
    if child_left = child.left
      child_left.right = child.right
    end
    if child_right = child.right
      child_right.left = child.left
    end

    child.parent = parent

    # if parent doesn't have children, make new child its only child
    if parent.child.nil?
      parent.child = child.right = child.left = child
    else # otherwise insert new child into parent's children list
      if current_child = parent.child
        child.left = current_child
        child.right = current_child.right
        if current_child_right = current_child.right
          current_child_right.left = child
        end
        current_child.right = child
      end
    end
    parent.degree += 1
    child.marked = false
  end

  # Makes sure the structure does not contain nodes in the root list with equal degrees
  private def consolidate
    roots = [] of Node(K, V)
    root = @next
    min = root
    # find the nodes in the list
    loop do
      if r = root
        roots << r
        root = r.right
      end
      break if root == @next
    end
    degrees = {} of Int32 => Node(K, V)
    roots.each do |rt|
      if m = min
        if key = rt.key
          min = rt if compare(key, m.key)
        end
      end
      # check if we need to merge
      unless degrees.has_key? rt.degree
        degrees[rt.degree] = rt
        next
      else # there is another node with the same degree, consolidate them
        degree = rt.degree
        while degrees.has_key? degree
          other_root_with_degree = degrees[degree]
          if compare(rt.key, other_root_with_degree.key) # determine which node is the parent, which one is the child
            smaller, larger = rt, other_root_with_degree
          else
            smaller, larger = other_root_with_degree, rt
          end
          link_nodes(larger, smaller)
          degrees.delete(degree)
          rt = smaller
          degree += 1
        end
        degrees[degree] = rt
        min = rt if min.not_nil!.key == rt.key # this fixes a bug with duplicate keys not being in the right order
      end
    end
    @next = min
  end

  private def cascading_cut(node)
    if p = node.parent
      if node.marked?
        cut(node, p)
        cascading_cut(p)
      else
        node.marked = true
      end
    end
  end

  # remove x from y's children and add x to the root list
  private def cut(x : Node(K, V), y : Node(K, V))
    x.left.not_nil!.right = x.right
    x.right.not_nil!.left = x.left
    y.degree -= 1
    if y.degree == 0
      y.child = nil
    elsif y.child == x
      y.child = x.right
    end
    if nxt = @next
      x.right = nxt
      x.left = nxt.left
      nxt.left = x
    end
    if x_left = x.left
      x_left.right = x
    end
    x.parent = nil
    x.marked = false
  end

end


class MaxHeap(K, V) < Heap(K, V)
  def initialize
    super(->(x : K, y : K) { (x <=> y) == 1 })
  end

  def max
    self.next
  end

  def max!
    self.pop
  end
end

class MinHeap(K, V) < Heap(K, V)
  def initialize
    super(->(x : K, y : K) { (x <=> y) == -1 })
  end

  def min
    self.next
  end

  def min!
    self.pop
  end
end
