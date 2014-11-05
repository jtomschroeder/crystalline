
require "base"

module MutableGraph(T, Edge)
  include Graph(T, Edge)

  def add_vertex(v)
    raise NotImplementedError.new
  end

  def add_edge(u, v)
    raise NotImplementedError.new
  end

  def add_vertices(*a)
    a.each { |v| add_vertex v }
  end

  def add_edges(*edges)
    edges.each { |edge| add_edge(edge[0], edge[1]) }
  end

  def remove_vertex(v)
    raise NotImplementedError.new
  end

  def remove_edge(u, v)
    raise NotImplementedError.new
  end

  def remove_vertices(*a)
    a.each { |v| remove_vertex v }
  end

end
