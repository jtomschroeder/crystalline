
require "./base"

abstract class MutableGraph(T, Edge) < Graph(T, Edge)

  abstract def add_vertex(v)
  abstract def add_edge(u, v)

  def add_vertices(a)
    a.each { |v| add_vertex v }
  end

  def add_edges(edges)
    edges.each { |edge| add_edge(edge[0], edge[1]) }
  end

  abstract def remove_vertex(v)
  abstract def remove_edge(u, v)
  
  def remove_vertices(a)
    a.each { |v| remove_vertex v }
  end

end
