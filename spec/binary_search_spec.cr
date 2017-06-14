require "spec"
require "../algorithms/search"

describe "Binary Search" do
  fibonacci_array = [0, 1, 1, 2, 3, 5, 8, 13]
  float_array = [0.1, 1.2, 2.3, 3.4, 4.5, 5.6, 6.7, 7.8, 8.9]
  alphabet_array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
  string_array = %w(Algeria Belgium Canada Denmark England Fiji Ghana Iceland Japan)

  describe "find some item" do
    it "returns some position in the fibonacci array" do
      value = Algorithms::Search.binary_search(fibonacci_array, 5)
      value.should eq(5)
    end

    it "returns some position in the float array" do
      value = Algorithms::Search.binary_search(float_array, 4.5)
      value.should eq(4)
    end

    it "returns some position in the alphabet array" do
      value = Algorithms::Search.binary_search(alphabet_array, 'e')
      value.should eq(4)
    end

    it "returns some position in the string array" do
      value = Algorithms::Search.binary_search(string_array, "Denmark")
      value.should eq(3)
    end
  end

  describe "find first item" do
    it "returns position 0 in the fibonacci array" do
      value = Algorithms::Search.binary_search(fibonacci_array, 0)
      value.should eq(0)
    end

    it "returns position 0 in the float array" do
      value = Algorithms::Search.binary_search(float_array, 0.1)
      value.should eq(0)
    end

    it "returns position 0 in the alphabet array" do
      value = Algorithms::Search.binary_search(alphabet_array, 'a')
      value.should eq(0)
    end

    it "returns position 0 in the string array" do
      value = Algorithms::Search.binary_search(string_array, "Algeria")
      value.should eq(0)
    end
  end

  describe "find last item" do
    it "returns position 7 in the fibonacci array" do
      value = Algorithms::Search.binary_search(fibonacci_array, 13)
      value.should eq(7)
    end

    it "returns position 7 in the float array" do
      value = Algorithms::Search.binary_search(float_array, 8.9)
      value.should eq(8)
    end

    it "returns position 25 in the alphabet array" do
      value = Algorithms::Search.binary_search(alphabet_array, 'z')
      value.should eq(25)
    end

    it "returns position 7 in the string array" do
      value = Algorithms::Search.binary_search(string_array, "Japan")
      value.should eq(8)
    end
  end
  describe "item not found" do
    it "returns nil" do
      value = Algorithms::Search.binary_search(fibonacci_array, 763)
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(float_array, 10.11)
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(alphabet_array, '&')
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(string_array, "Malta")
      value.should eq(nil)
    end
  end

  describe "invalid input" do
    it "returns nil" do
      value = Algorithms::Search.binary_search(fibonacci_array, nil)
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(alphabet_array, nil)
      value.should eq(nil)
    end

    it "returns nil" do
      value = Algorithms::Search.binary_search(string_array, nil)
      value.should eq(nil)
    end
  end
end
