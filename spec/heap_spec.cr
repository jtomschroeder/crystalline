require "../containers/heap"
require "spec"

def setup_heap
  random_array = [] of Int32
  num_items = 100
  num_items.times { random_array << rand(num_items) }
  heap = MaxHeap(Int32, Int32).new
  random_array.each { |n| heap << n }
  {heap, random_array, num_items}
end

describe "Heap" do
  describe "(empty)" do
    it "should return nil when getting the maximum" do
      heap = MaxHeap(Int32, Int32).new
      heap.max!.should be_nil
    end

    it "should let you insert and remove one item" do
      heap = MaxHeap(Int32, Int32).new

      heap.size.should eq(0)

      heap.push(1)
      heap.size.should eq(1)

      heap.max!.should eq(1)
      heap.size.should eq(0)
    end

    it "should let you initialize with an array" do
      heap = MaxHeap(Int32, Int32).new
      [1, 2, 3].each { |n| heap << n }
      heap.size.should eq(3)
    end
  end

  describe "(non-empty)" do
    it "should display the correct size" do
      heap, random_array, num_items = setup_heap()
      heap.size.should eq(num_items)
    end

    it "should have a next value" do
      heap, random_array, num_items = setup_heap()
      heap.next.should be_truthy
      heap.next_key.should be_truthy
    end

    it "should delete random keys" do
      heap, random_array, num_items = setup_heap()
      heap.delete(random_array[0]).should eq(random_array[0])
      heap.delete(random_array[1]).should eq(random_array[1])

      ordered = [] of Int32
      until heap.empty?
        if i = heap.max!
          ordered << i
        end
      end
      ordered.should eq random_array[2..-1].sort.reverse
    end

    it "should delete all keys" do
      heap, random_array, num_items = setup_heap()
      ordered = [] of Int32
      random_array.size.times do |t|
        if i = heap.delete(random_array[t])
          ordered << i
        end
      end
      heap.empty?.should be_true
      ordered.should eq random_array
    end

    it "should be in max->min order" do
      heap, random_array, num_items = setup_heap()
      ordered = [] of Int32
      until heap.empty?
        if i = heap.max!
          ordered << i
        end
      end
      ordered.should eq random_array.sort.reverse
    end

    it "should change certain keys" do
      numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100, 101]
      heap = MinHeap(Int32, Int32).new
      numbers.each { |n| heap << n }
      heap.change_key(101, 50)
      heap.pop
      heap.pop
      heap.change_key(8, 0)
      ordered = [] of Int32
      until heap.empty?
        if i = heap.min!
          ordered << i
        end
      end
      ordered.should eq [8, 3, 4, 5, 6, 7, 9, 10, 101, 100]
    end

    it "should not delete keys it doesn't have" do
      ary = [1, 2, 3, 4, 5, 6, 7, 8]
      heap = MaxHeap(Int32, Int32).new
      ary.each { |n| heap << n }
      heap.delete(0).should be_nil
      heap.size.should eq ary.size
    end

    it "should delete certain keys" do
      numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100, 101]
      heap = MinHeap(Int32, Int32).new
      numbers.each { |n| heap << n }
      heap.delete(5)
      heap.pop
      heap.pop
      heap.delete(100)
      ordered = [] of Int32
      until heap.empty?
        if i = heap.min!
          ordered << i
        end
      end
      ordered.should eq [3, 4, 6, 7, 8, 9, 10, 101]
    end

    it "should let you merge with another heap" do
      heap, random_array, num_items = setup_heap()
      numbers = [1, 2, 3, 4, 5, 6, 7, 8]
      otherheap = MaxHeap(Int32, Int32).new
      numbers.each { |n| otherheap << n }
      otherheap.size.should eq(8)
      heap.merge!(otherheap)

      ordered = [] of Int32
      until heap.empty?
        if i = heap.max!
          ordered << i
        end
      end

      ordered.should eq (random_array + numbers).sort.reverse
    end

    describe "min-heap" do
      it "should be in min->max order" do
        heap, random_array, num_items = setup_heap()
        heap = MinHeap(Int32, Int32).new
        random_array.each { |n| heap << n }
        ordered = [] of Int32
        until heap.empty?
          if i = heap.min!
            ordered << i
          end
        end
        ordered.should eq random_array.sort
      end
    end
  end
end
