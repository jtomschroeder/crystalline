require "./spec_helper"

describe "KMP Search" do
  describe "finds some pattern" do
    it "returns its indices in the given text" do
      value = Algorithms::Search.kmp_search("babccabc", "abc")
      value.should eq([1, 5])
    end

    it "returns no results" do
      value = Algorithms::Search.kmp_search("the quick brown fox jumped over the lazy dog.", "abc")
      value.should eq([] of Int32)
    end
  end
end
