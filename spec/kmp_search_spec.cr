require "spec"
require "../algorithms/kmp_search"

describe "KMP Search" do
  describe "find some pattern" do
    it "returns some indices in the given text" do
      value = Algorithms::Search.kmp_search("babccabc", "abc")
      value.should eq([1, 5])
    end
  end
end
