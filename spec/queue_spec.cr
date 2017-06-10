require "spec"
require "../containers/queue"

describe "Queue" do
  describe "(empty)" do
    it "should return nil when sent #pop?" do
      queue = Queue(Int32).new
      queue.pop?.should be_nil
    end

    it "should return a size of 1 when sent #push" do
      queue = Queue(Int32).new
      queue.push(1)
      queue.size.should eq(1)
    end

    it "should return nil when sent #next?" do
      queue = Queue(Int32).new
      queue.next?.should be_nil
    end

    it "should return empty?" do
      queue = Queue(Int32).new
      queue.empty?.should be_true
    end
  end

  describe "(non-empty)" do
    it "should return first pushed object" do
      queue = Queue(Int32).new([1, 2, 3, 5, 8])
      queue.pop.should eq(1)
    end

    it "should return the size" do
      queue = Queue(Int32).new([1, 2, 3, 5, 8])
      queue.size.should eq(5)
    end

    it "should not return empty?" do
      queue = Queue(Int32).new([1, 2, 3, 5, 8])
      queue.empty?.should be_false
    end

    it "should iterate in FIFO order" do
      queue = Queue(Int32).new([1, 2, 3, 5, 8])
      arr = [] of Int32
      queue.each { |obj| arr << obj }
      arr.should eq([1, 2, 3, 5, 8])
    end

    it "should return nil after all gets" do
      queue = Queue(Int32).new([1, 2, 3, 5, 8])
      5.times { queue.pop }
      queue.pop?.should be_nil
      queue.next?.should be_nil
    end
  end
end
