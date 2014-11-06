
require "mutable"

# TODO: refactor AdjancencyGraph's common implementation

class DirectedAdjacencyGraph(T, EdgeList)
  include MutableGraph(T, DirectedEdge)

  def initialize(*other_graphs)
    @vertice_dict = {} of T => EdgeList(T)

    other_graphs.each do |g|
      g.each_vertex {|v| add_vertex v}
      g.each_edge {|v,w| add_edge v,w}
    end
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

  def directed?; true; end

  def remove_edge(u, v)
    @vertice_dict[u].delete(v) if @vertice_dict[u]
  end

  protected def basic_add_edge(u, v)
    @vertice_dict[u].add(v)
  end

end

class AdjacencyGraph(T, EdgeList)
  include MutableGraph(T, UndirectedEdge)

  def initialize(*other_graphs)
    @vertice_dict = {} of T => EdgeList(T)
    
    other_graphs.each do |g|
      g.each_vertex {|v| add_vertex v}
      g.each_edge {|v,w| add_edge v,w}
    end
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

  # above methods identical to DirectedAdjacencyGraph

  def directed?; false; end

  def remove_edge(u, v)
    @vertice_dict[u].delete(v) if @vertice_dict[u]
    @vertice_dict[v].delete(u) if @vertice_dict[v]
  end

  protected def basic_add_edge(u, v)
    @vertice_dict[u].add(v)
    @vertice_dict[v].add(u)
  end

end

module Graph(T, Edge)

  def to_adjacency
    result = directed? ? DirectedAdjacencyGraph(T, Set).new : AdjacencyGraph(T, Set).new
    each_vertex { |v| result.add_vertex(v) }
    each_edge { |u,v| result.add_edge(u, v) }
    result
  end

  def reverse
    return self unless directed?
    result = DirectedAdjacencyGraph(T, Set).new
    each_vertex { |v| result.add_vertex v }
    each_edge { |u,v| result.add_edge(v, u) }
    result
  end

end
