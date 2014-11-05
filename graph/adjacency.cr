
require "mutable"

class DirectedAdjacencyGraph(T, EdgeList)
  include MutableGraph(T, DirectedEdge)

  def initialize
    @vertice_dict = {} of T => EdgeList(T)
  end

  def each_vertex
    @vertice_dict.each_key { |k| yield k }
  end

  def each_adjacent(v)
    begin
      adjacency_list = @vertice_dict[v]
      adjacency_list.each { |e| yield e }
    rescue MissingKey
      raise NoVertexError.new("No vertex #{v}.")
    end
  end

  def directed?; true; end

  def has_vertex?(v)
    @vertice_dict.has_key?(v)
  end

  def has_edge? (u, v)
    has_vertex?(u) && @vertice_dict[u].includes?(v)
  end

  def add_vertex (v)
    @vertice_dict[v] ||= EdgeList(T).new
  end

  def add_edge(u, v)
    add_vertex(u) # ensure key
    add_vertex(v) # ensure key
    basic_add_edge(u, v)
  end

  def remove_vertex (v)
    @vertice_dict.delete(v)
    # remove v from all adjacency lists
    @vertice_dict.each_value { |adjList| adjList.delete(v) }
  end

  def remove_edge(u, v)
    @vertice_dict[u].delete(v) if @vertice_dict[u]
  end

  protected def basic_add_edge(u, v)
    @vertice_dict[u].add(v)
  end

end

module Graph(T, Edge)

  def reverse
    return self unless directed?
    result = DirectedAdjacencyGraph(T, Set).new
    each_vertex { |v| result.add_vertex v }
    each_edge { |u,v| result.add_edge(v, u) }
    result
  end

end
