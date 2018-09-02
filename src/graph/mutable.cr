require "./base"

module Crystalline::Graph
  abstract class MutableGraph(T, Edge, EdgeList) < Graph(T, Edge)
    protected getter vertice_dict

    def initialize(*other_graphs)
      @vertice_dict = {} of T => EdgeList

      other_graphs.each do |g|
        g.each_vertex { |v| add_vertex v }
        g.each_edge { |v, w| add_edge v, w }
      end
    end

    def ==(x)
      return false unless x.is_a? MutableGraph
      # this way looks more correct, but then x.to_adjacency != x
      # @vertice_dict == x.vertice_dict
      # so convert each edgelist to array
      return false unless @vertice_dict.keys == x.vertice_dict.keys
      each_vertex do |v|
        return false unless @vertice_dict[v].to_a == x.vertice_dict[v].to_a
      end
      true
    end

    def each_vertex
      @vertice_dict.each_key { |k| yield k }
    end

    def has_vertex?(v)
      @vertice_dict.has_key?(v)
    end

    def each_adjacent(v)
      begin
        adjacency_list = @vertice_dict[v]
        adjacency_list.each { |e| yield e }
      rescue KeyError
        raise NoVertexError.new("No vertex #{v}.")
      end
    end

    def add_vertices(a)
      a.each { |v| add_vertex v }
    end

    def add_edges(edges)
      edges.each { |edge| add_edge(edge[0], edge[1]) }
    end

    abstract def remove_edge(u, v)

    def remove_vertices(a)
      a.each { |v| remove_vertex v }
    end

    def has_edge?(u, v)
      has_vertex?(u) && @vertice_dict[u].includes?(v)
    end

    def add_vertex(v)
      @vertice_dict[v] ||= EdgeList.new
    end

    protected abstract def basic_add_edge(u, v)

    def add_edge(u, v)
      add_vertex(u) # ensure key
      add_vertex(v) # ensure key
      basic_add_edge(u, v)
    end

    def remove_vertex(v)
      @vertice_dict.delete(v)
      # remove v from all adjacency lists
      @vertice_dict.each_value { |adjList| adjList.delete(v) }
    end
  end
end
