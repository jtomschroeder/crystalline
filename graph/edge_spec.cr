
require "spec"
require "./base"

describe "Edges" do
  it "should support directed edges" do
    e = DirectedEdge(Int32).new(1, 2)
    e.source.should eq 1
    e.target.should eq 2
    e.to_a.should eq [1, 2]
    e.to_s.should eq "(1-2)"
    e.reverse.to_s.should eq "(2-1)"
    e[0].should eq 1
    e[1].should eq 2
    DirectedEdge(Int32).new(1, 2).eql?(DirectedEdge(Int32).new(1, 2)).should be_true
    DirectedEdge(Int32).new(1, 2).eql?(DirectedEdge(Int32).new(1, 3)).should be_false
    DirectedEdge(Int32).new(1, 2).eql?(DirectedEdge(Int32).new(2, 1)).should be_false
  end

  it "should support undirected edges" do
    e = UndirectedEdge(Int32).new(1, 2)
    e.source.should eq 1
    e.target.should eq 2
    e.to_a.should eq [1, 2]
    e.to_s.should eq "(1=2)"
    e[0].should eq 1
    e[1].should eq 2
    UndirectedEdge(Int32).new(1, 2).eql?(UndirectedEdge(Int32).new(1, 2)).should be_true
    UndirectedEdge(Int32).new(1, 2).eql?(UndirectedEdge(Int32).new(1, 3)).should be_false
    UndirectedEdge(Int32).new(1, 2).eql?(UndirectedEdge(Int32).new(2, 1)).should be_true
    UndirectedEdge(Int32).new(1, 2).hash.should eq(UndirectedEdge(Int32).new(1, 2).hash)
  end
end
