require "./spec_helper"

def generate_splay(num_items : Int32)
  map = SplayTreeMap(Int32, Int32).new
  num_items.times { |i| map[i] = i * 2 }
  map
end

describe "SplayTreeMap" do
  describe "(empty)" do
    it "should let you push stuff in" do
      tree = SplayTreeMap(Int32, Int32).new
      100.times { |x| tree[x] = x }
      tree.size.should eq(100)
    end

    it "should return 0 for size" do
      tree = SplayTreeMap(Int32, Int32).new
      tree.size.should eq(0)
    end

    it "should return nil for #min and #max" do
      tree = SplayTreeMap(Int32, Int32).new
      tree.min.should be_nil
      tree.max.should be_nil
    end

    it "should return nil for #delete" do
      tree = SplayTreeMap(Int32, Int32).new
      tree.delete(12).should be_nil
    end

    it "should return nil for #get" do
      tree = SplayTreeMap(Int32, Int32).new
      tree[4235].should be_nil
    end
  end

  describe "(non-empty)" do
    it "should return correct size (unique items)" do
      map = generate_splay(100)
      map[1] = 1 # reassign key 1 to verify push reassigns value
      map.size.should eq(100)
    end

    it "should have correct height (worst case is when items are inserted in order, and height = num items inserted)" do
      map = generate_splay(100)
      map.clear
      10.times { |x| map[x] = x }
      map.height.should eq(10)
    end

    it "should return correct max and min keys" do
      map = generate_splay(100)

      map.min.should_not be_nil
      mapmin = map.min
      mapmin[0].should eq(0) if mapmin

      map.max.should_not be_nil
      mapmax = map.max
      mapmax[0].should eq(99) if mapmax
    end

    it "should not #has_key? keys it doesn't have" do
      map = generate_splay(100)
      map.has_key?(10000).should be_false
    end

    it "should #has_key? keys it does have" do
      map = generate_splay(100)
      map.has_key?(52).should be_true
    end

    it "should remove any key" do
      map = generate_splay(20)
      map.has_key?(0).should be_true
      map.delete(0).should eq(0)
      map.has_key?(0).should be_false
    end

    it "should remove all keys" do
      map = generate_splay(20)
      20.times do |i|
        map.has_key?(i).should be_true
        map.delete(i).should eq(i * 2)
        map.has_key?(i).should be_false
      end
    end

    it "should let you iterate with #each" do
      map = generate_splay(100)
      count = 0
      map.each do |key, value|
        key.should eq(value / 2)
        count += 1
      end
      count.should eq(100)
    end
  end
end
