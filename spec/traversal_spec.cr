
require "spec"
require "../graph/adjacency"
require "../graph/traversal"

def setup
  edges = [{1, 2}, {2, 3}, {2, 4}, {4, 5}, {1, 6}, {6, 4}]

  dg = DirectedAdjacencyGraph(Int32, Array).new
  dg.add_edges(edges)

  bfs = dg.bfs_iterator(1)
  dfs = dg.dfs_iterator(1)

  ug = AdjacencyGraph(Int32, Array).new
  ug.add_edges(edges)
  {dg, bfs, dfs, ug}
end

describe "Traversal" do

  it "bfs_iterator_creation" do
    dg, bfs, dfs, ug = setup()
    bfs.at_beginning?.should be_true
    bfs.at_end?.should be_false
    bfs.start_vertex.should eq 1
    bfs.graph.should eq dg
  end

  it "bfs_visiting" do
    dg, bfs, dfs, ug = setup()
    expected = [1, 2, 6, 3, 4, 5]
    bfs.to_a.should eq expected
    ug.bfs_iterator.to_a.should eq expected
    ug.bfs_iterator(1).to_a.should eq expected
    ug.bfs_iterator(2).to_a.should eq [2, 1, 3, 4, 6, 5]
  end

  it "bfs_event_handlers" do
    dg, bfs, dfs, ug = setup()

    expected = "examine_vertex : 1
examine_edge   : 1-2
tree_edge      : 1-2
examine_edge   : 1-6
tree_edge      : 1-6
finished_vertex: 1
examine_vertex : 2
examine_edge   : 2-3
tree_edge      : 2-3
examine_edge   : 2-4
tree_edge      : 2-4
finished_vertex: 2
examine_vertex : 6
examine_edge   : 6-4
back_edge      : 6-4
finished_vertex: 6
examine_vertex : 3
finished_vertex: 3
examine_vertex : 4
examine_edge   : 4-5
tree_edge      : 4-5
finished_vertex: 4
examine_vertex : 5
examine_edge   : 5-3
forward_edge   : 5-3
finished_vertex: 5
"
    s = ""
    dg.add_edge 5, 3 # for the forward_edge 5-3

    bfs.vertex_event       = ->(v : Int32)            { s += "examine_vertex : #{v}\n" }
    bfs.edge_event         = ->(u : Int32, v : Int32) { s += "examine_edge   : #{u}-#{v}\n" }
    bfs.tree_edge_event    = ->(u : Int32, v : Int32) { s += "tree_edge      : #{u}-#{v}\n"}
    bfs.back_edge_event    = ->(u : Int32, v : Int32) { s += "back_edge      : #{u}-#{v}\n"}
    bfs.forward_edge_event = ->(u : Int32, v : Int32) { s += "forward_edge   : #{u}-#{v}\n"}

    bfs.each { |v| s += "finished_vertex: #{v}\n" }

    s.should eq expected
  end

  it "dfs_visiting" do
    dg, bfs, dfs, ug = setup()
    dg.dfs_iterator.to_a.should eq [1, 6, 4, 5, 2, 3]
    dg.dfs_iterator(1).to_a.should eq [1, 6, 4, 5, 2, 3]
    dg.dfs_iterator(2).to_a.should eq [2, 4, 5, 3]
  end

  it "dfs_event_handlers" do
    dg, bfs, dfs, ug = setup()

    expected = "examine_vertex : 1
examine_edge   : 1-2
tree_edge      : 1-2
examine_edge   : 1-6
tree_edge      : 1-6
finished_vertex: 1
examine_vertex : 6
examine_edge   : 6-4
tree_edge      : 6-4
finished_vertex: 6
examine_vertex : 4
examine_edge   : 4-5
tree_edge      : 4-5
finished_vertex: 4
examine_vertex : 5
examine_edge   : 5-3
tree_edge      : 5-3
finished_vertex: 5
examine_vertex : 3
finished_vertex: 3
examine_vertex : 2
examine_edge   : 2-3
forward_edge   : 2-3
examine_edge   : 2-4
forward_edge   : 2-4
finished_vertex: 2
"
    s = ""
    dg.add_edge 5, 3

    dfs.vertex_event       = ->(v : Int32)            { s += "examine_vertex : #{v}\n" }
    dfs.edge_event         = ->(u : Int32, v : Int32) { s += "examine_edge   : #{u}-#{v}\n" }
    dfs.tree_edge_event    = ->(u : Int32, v : Int32) { s += "tree_edge      : #{u}-#{v}\n"}
    dfs.back_edge_event    = ->(u : Int32, v : Int32) { s += "back_edge      : #{u}-#{v}\n"}
    dfs.forward_edge_event = ->(u : Int32, v : Int32) { s += "forward_edge   : #{u}-#{v}\n"}

    dfs.each { |v| s += "finished_vertex: #{v}\n" }

    s.should eq expected
  end

  it "bfs_search_tree" do
    dg, bfs, dfs, ug = setup()
    dg.bfs_search_tree_from(1).edges.sort.sum("", &.to_s).should eq "(1-2)(1-6)(2-3)(2-4)(4-5)"
  end

end
