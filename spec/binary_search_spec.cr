
require "spec"
require "../algorithms/search"

describe "Binary Search" do

  fibonacci_array = [0,1,1,2,3,5,8,13]

  describe "find some item" do
    it "returns some position" do
      value = Algorithms::Search.binary_search(fibonacci_array, 5)
      value.should eq(5)
    end
  end

  describe "find first item" do
    it "returns position 0" do
      value = Algorithms::Search.binary_search(fibonacci_array, 0)
      value.should eq(0)
    end
  end

  describe "find last item" do
    it "returns position 7" do
      value = Algorithms::Search.binary_search(fibonacci_array, 13)
      value.should eq(7)
    end
  end
  
  describe "item not found" do
    it "returns nil" do
      value = Algorithms::Search.binary_search(fibonacci_array, 763)
      value.should eq(nil)
    end
  end

  describe "invalid input" do
    it "returns nil" do
      value = Algorithms::Search.binary_search(fibonacci_array, "hello")
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(fibonacci_array, nil)
      value.should eq(nil)
    end
  end

end