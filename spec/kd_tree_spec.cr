
require "spec"
require "../containers/kd_tree"

describe "KDTree" do
  it "should function with pairs" do
    kdtree = KDTree(Int32).new({ 0 => [4, 3], 1 => [3, 0], 2 => [-1, 2], 3 => [6, 4], 4 => [3, -5], 5 => [-2, -5] })
    kdtree.find_nearest([0, 0], 2).should eq([[5, 2], [9, 1]])
  end
end
