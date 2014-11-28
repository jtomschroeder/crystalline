
require "spec"
require "./adjacency"
require "set"

def setup()
  dg = DirectedAdjacencyGraph(Int32, Set).new
  [{1, 2}, {2, 3}, {3, 2}, {2, 4}].each { |i| dg.add_edge(i[0], i[1]) }
  dg
end

describe "DirectedAdjacencyGraph" do

  it "empty_graph" do
    dg = DirectedAdjacencyGraph(Int32, Set).new
    dg.empty?.should be_true
    dg.directed?.should be_true
    dg.has_edge?(2,1).should be_false
    dg.has_vertex?(3).should be_false
    expect_raises(NoVertexError, "No vertex 3.") { dg.out_degree(3) }
    dg.vertices.should eq [] of Int32
    dg.size.should eq 0
    dg.num_vertices.should eq 0
    dg.num_edges.should eq 0
    dg.edges.should eq [] of DirectedEdge(Int32)
  end

  it "add" do
    dg = DirectedAdjacencyGraph(Int32, Set).new
    dg.add_edge(1, 2)
    
    dg.empty?.should be_false
    
    dg.has_edge?(1, 2).should be_true
    dg.has_edge?(2, 1).should be_false
    
    dg.has_vertex?(1).should be_true
    dg.has_vertex?(2).should be_true
    dg.has_vertex?(3).should be_false
    
    dg.vertices.sort.should eq [1, 2]
    dg.edges.sum("", &.to_s).should eq "(1-2)"
    
    dg.adjacent_vertices(1).should eq [2]
    dg.adjacent_vertices(2).should eq [] of Int32
    
    dg.out_degree(1).should eq 1
    dg.out_degree(2).should eq 0
  end

  it "edges" do
    dg = setup()
    dg.edges.length.should eq 4
    dg.edges.map(&.source).sort.should eq [1, 2, 2, 3]
    dg.edges.map(&.target).sort.should eq [2, 2, 3, 4]
    dg.edges.map(&.to_s).sort.join.should eq "(1-2)(2-3)(2-4)(3-2)"
  end
  
  it "vertices" do
    dg = setup()
    dg.vertices.sort.should eq [1, 2, 3, 4]
  end
  
  it "edges_from_to?" do
    dg = setup()
    dg.has_edge?(1, 2).should be_true
    dg.has_edge?(2, 3).should be_true
    dg.has_edge?(3, 2).should be_true
    dg.has_edge?(2, 4).should be_true
    dg.has_edge?(2, 1).should be_false
    dg.has_edge?(3, 1).should be_false
    dg.has_edge?(4, 1).should be_false
    dg.has_edge?(4, 2).should be_false
  end
  
  it "remove_edges" do
    dg = setup()
    dg.remove_edge 1, 2
    dg.has_edge?(1, 2).should be_false
    dg.remove_edge 1, 2
    dg.has_edge?(1, 2).should be_false
    dg.remove_vertex 3
    dg.has_vertex?(3).should be_false
    dg.has_edge?(2, 3).should be_false
    dg.edges.sum("", &.to_s).should eq "(2-4)"
  end
  
  it "add_vertices" do
    dg = DirectedAdjacencyGraph(Int32, Set).new
    dg.add_vertices [1, 3, 2, 4]
    dg.vertices.sort.should eq [1, 2, 3, 4]
    
    dg.remove_vertices [1, 3]
    dg.vertices.sort.should eq [2, 4]
  end
  
  it "reverse" do
    dg = setup()
    reverted = dg.reverse
    dg.each_edge do |u,v|
      reverted.has_edge?(v,u).should be_true
    end
  end

end
