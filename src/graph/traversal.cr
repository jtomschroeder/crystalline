require "./base"
require "./adjacency"
require "./iterator"
require "../containers/common"

module Crystalline::Graph
  abstract class GraphVisitor(T) < AbstractIterator(T)
    getter graph

    enum Mark
      WHITE
      GRAY
      BLACK
    end
    getter color_map : Hash(T, Mark)

    def initialize
      @color_map = Hash(T, Mark).new(Mark::WHITE)
    end

    def reset
      @color_map = Hash(T, Mark).new(Mark::WHITE)
    end

    # def finished_vertex?(v)
    #   @color_map[v] == Mark::BLACK
    # end

    # def distance_to_root(v)
    #   if dist_map = @dist_map
    #     dist_map[v]
    #   end
    # end

    def follow_edge?(u, v)
      @color_map[v] == Mark::WHITE
    end
  end

  class GraphIterator(T) < GraphVisitor(T)
    # generic aliases don't work?
    # alias VertexCallback = Proc(T, Nil)?
    # alias EdgeCallback = Proc(T, T, Nil)?

    getter start_vertex
    property vertex_event : Proc(T, Nil)?
    property edge_event : Proc(T, T, Nil)?
    property tree_edge_event : Proc(T, T, Nil)?
    property back_edge_event : Proc(T, T, Nil)?
    property forward_edge_event : Proc(T, T, Nil)?
    property finish_vertex_event : Proc(T, Nil)?

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

    # executes a callback fn if the callback fn is defined
    private def callback(fn, *args)
      if fn
        fn.call(*args)
      end
    end

    def basic_forward
      u = next_vertex
      callback(vertex_event, u)
      graph.each_adjacent(u) do |v|
        callback(edge_event, u, v)
        if follow_edge?(u, v)             # (u,v) is a tree edge
          callback(tree_edge_event, u, v) # also discovers v
          color_map[v] = Mark::GRAY       # color of v was :WHITE
          @waiting.push(v)
        else # (u,v) is a non tree edge
          if color_map[v] == Mark::GRAY
            callback(back_edge_event, u, v) # (u,v) has gray target
          else
            callback(forward_edge_event, u, v) # (u,v) has black target
          end
        end
      end
      color_map[u] = Mark::BLACK
      callback(finish_vertex_event, u)
      u
    end

    def basic_backward
      raise "basic_backward is not supported" # TODO - what to do with it?
    end
  end

  class BFSIterator(T, Edge) < GraphIterator(T)
    @start_vertex : T?

    def initialize(@graph : Graph(T, Edge), start = @graph.find { |x| true })
      @waiting = [] of T
      @dist_map = Hash(T, T).new(0)
      @color_map = Hash(T, Mark).new(Mark::WHITE)
      @start_vertex = start
      set_to_begin
    end

    def next_vertex
      # waiting is a queue
      @waiting.shift
    end
  end

  class Graph(T, Edge)
    def bfs_iterator(v = self.find { |x| true })
      BFSIterator(T, Edge).new(self, v)
    end

    def bfs_search_tree_from(v)
      bfs = bfs_iterator(v)
      tree = DirectedAdjacencyGraph(T, Set(T)).new
      bfs.tree_edge_event = ->(from : T, to : T) { tree.add_edge(from, to); nil }
      bfs.set_to_end # does the search
      tree
    end
  end

  class DFSIterator(T, Edge) < GraphIterator(T)
    @start_vertex : T?

    def initialize(@graph : Graph(T, Edge), start = @graph.find { |x| true })
      @waiting = [] of T
      @dist_map = Hash(T, T).new()
      @color_map = Hash(T, Mark).new(Mark::WHITE)
      @start_vertex = start
      set_to_begin
    end

    def next_vertex
      # waiting is a stack
      @waiting.pop
    end
  end

  abstract class Graph(T, Edge)
    def dfs_iterator(v = self.find { |x| true })
      DFSIterator(T, Edge).new(self, v)
    end
  end
end
