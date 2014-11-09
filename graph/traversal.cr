
require "base"
require "iterator"
require "../containers/common"

module GraphVisitor(T)
  include Iterator(T)

  getter graph, color_map

  enum Mark
    WHITE
    GRAY
    BLACK
  end

  def reset
    @color_map = Hash(T, Mark).new(Mark::WHITE)
  end

  def finished_vertex?(v)
    @color_map[v] == Mark::BLACK
  end

  def distance_to_root(v)
    if dist_map = @dist_map
      dist_map[v]
    end
  end

  def follow_edge?(u, v)
    @color_map[v] == Mark::WHITE
  end

end

module GraphIterator(T)
  include GraphVisitor(T)

  getter start_vertex
  property vertex_event, edge_event, tree_edge_event, back_edge_event, forward_edge_event, finish_vertex_event

  def at_beginning?
    @color_map.size == 1
  end

  def at_end?
    @waiting.empty?
  end

  def set_to_begin
    if start_vertex = @start_vertex
      @color_map[start_vertex] = Mark::GRAY
      @waiting = [start_vertex] # a queue
    end
  end

  def basic_forward
    u = next_vertex
    if e = vertex_event; e.call(u); end
    graph.each_adjacent(u) do |v|
      if e = edge_event; e.call(u, v); end
      if follow_edge?(u, v) # (u,v) is a tree edge
        if e = tree_edge_event; e.call(u, v); end # also discovers v
        color_map[v] = Mark::GRAY # color of v was :WHITE
        @waiting.push(v)
      else # (u,v) is a non tree edge
        if color_map[v] == Mark::GRAY
          # (u,v) has gray target
          if e = back_edge_event; e.call(u, v); end
        else
          # (u,v) has black target
          if e = forward_edge_event; e.call(u, v); end
        end
      end
    end
    color_map[u] = Mark::BLACK
    if e = finish_vertex_event; e.call(u); end
    u
  end

end

class BFSIterator(T)
  include GraphIterator(T)

  def initialize(@graph, start = @graph.find { |x| true })
    @color_map :: Hash(T, Mark)
    reset
    @start_vertex :: T
    @start_vertex = start
    @waiting :: Array(T)
    @waiting = [] of T
    @dist_map :: Hash(T, T)
    @dist_map = Hash(T, T).new(0)
    set_to_begin
  end

  def next_vertex
    # waiting is a queue
    @waiting.shift
  end
end

module Graph(T)

  def bfs_iterator(v = self.find { |x| true })
    BFSIterator(T).new(self, v)
  end

  def bfs_search_tree_from(v)
    require "adjacency"
    bfs  = bfs_iterator(v)
    tree = DirectedAdjacencyGraph(T, Set).new
    bfs.tree_edge_event = ->(from : T, to : T) { tree.add_edge(from, to) }
    bfs.set_to_end # does the search
    tree
  end

end

class DFSIterator(T)
  include GraphIterator(T)

  def initialize(@graph, start = @graph.find { |x| true })
    @color_map :: Hash(T, Mark)
    reset
    @start_vertex :: T
    @start_vertex = start
    @waiting :: Array(T)
    @waiting = [] of T
    @dist_map :: Hash(T, T)
    @dist_map = Hash(T, T).new(0)
    set_to_begin
  end

  def next_vertex
    # waiting is a stack
    @waiting.pop
  end

end

module Graph(T)
  def dfs_iterator(v = self.detect { |x| true })
    DFSIterator(T).new(self, v)
  end
end
