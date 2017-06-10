require "./base"

abstract class MutableGraph(T, Edge, EdgeList) < Graph(T, Edge)
  def initialize(*other_graphs)
    @vertice_dict = {} of T => EdgeList

    other_graphs.each do |g|
      g.each_vertex { |v| add_vertex v }
      g.each_edge { |v, w| add_edge v, w }
    end
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
