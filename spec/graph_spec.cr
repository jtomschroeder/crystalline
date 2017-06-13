require "spec"
require "../graph/adjacency"
require "set"

def setup_graph
  edges = [{1, 2}, {2, 3}, {2, 4}, {4, 5}, {1, 6}, {6, 4}]
  loan_vertices = [7, 8, 9]

  dg1 = DirectedAdjacencyGraph(Int32, Set(Int32)).new
  edges.each { |e| dg1.add_edge(e[0], e[1]) }
  loan_vertices.each { |v| dg1.add_vertex(v) }

  dg2 = DirectedAdjacencyGraph(Int32, Set(Int32)).new
  edges.each { |e| dg2.add_edge(e[0], e[1]) }
  loan_vertices.each { |v| dg2.add_vertex(v) }

  ug = AdjacencyGraph(Int32, Array(Int32)).new
  ug.add_edges(edges)
  ug.add_vertices(loan_vertices)

  {dg1, dg2, ug}
end

describe "Graph" do
  it "equality" do
    dg1, dg2, ug = setup_graph()
    dg1.should eq dg1
    ug.should_not eq dg1
    dg1.should_not eq ug
    dg1.should eq dg2
    dg1.add_vertex 42
    dg1.should_not eq dg2
  end

  it "to_adjacency" do
    dg1, dg2, ug = setup_graph()
    dg1.should eq dg1.to_adjacency
    ug.should eq ug.to_adjacency
  end

  it "merge" do
    dg1, dg2, ug = setup_graph()
    merge = DirectedAdjacencyGraph(Int32, Array(Int32)).new(dg1, ug)
    merge.num_edges.should eq 12
    merge.num_vertices.should eq 9
    merge = DirectedAdjacencyGraph(Int32, Set(Int32)).new(dg1, dg1)
    merge.num_edges.should eq 6
    merge.num_vertices.should eq 9
  end
end
