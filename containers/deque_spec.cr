#!/usr/bin/env bin/crystal --run

require "spec"
require "deque"

describe "Deque" do
  describe "(empty deque)" do
    it "should return nil when popping objects" do
      deque = Deque(Int32).new
      deque.pop_front.should be_nil
      deque.pop_back.should be_nil
    end

    it "should return a size of 1 when sent #push_front" do
      deque = Deque(Int32).new
      deque.push_front(1)
      deque.size.should eq(1)
    end

    it "should return a size of 1 when sent #push_back" do
      deque = Deque(Int32).new
      deque.push_back(1)
      deque.size.should eq(1)
    end

    it "should return nil when sent #front and #back" do
      deque = Deque(Int32).new
      deque.front.should be_nil
      deque.back.should be_nil
    end

    it "should be empty" do
      deque = Deque(Int32).new
      deque.empty?.should be_true
    end

    it "should be empty when initialized with empty array" do
      deque = Deque(Int32).new([] of Int32)
      deque.empty?.should be_true
    end
  end

  describe "(non-empty deque)" do
    it "should return last pushed object with pop_back" do
      deque = Deque(Int32).new([1, 2, 3, 4])
      deque.pop_back.should eq(4)
      deque.pop_back.should eq(3)
    end

    it "should return first pushed object with pop_front" do
      deque = Deque(Int32).new([1, 2, 3, 4])
      deque.pop_front.should eq(1)
      deque.pop_front.should eq(2)
    end

    it "should return a size greater than 0" do
      deque = Deque(Int32).new([1, 2, 3, 4])
      deque.size.should eq(4)
    end

    it "should not be empty" do
      deque = Deque(Int32).new([1, 2, 3, 4])
      deque.empty?.should be_false
    end

    it "should iterate in LIFO order with #reverse_each" do
      deque = Deque(Int32).new([1, 2, 3, 4, 5])
      deque.pop_front
      arr = [] of Int32
      deque.reverse_each { |obj| arr << obj }
      arr.should eq([5, 4, 3, 2])
    end

    it "should iterate in FIFO order with #each" do
      deque = Deque(Int32).new([0, 1, 2, 3, 4])
      deque.pop_back
      arr = [] of Int32
      deque.each { |obj| arr << obj }
      arr.should eq([0, 1, 2, 3])
    end

    it "should return nil after everything's popped" do
      deque = Deque(Int32).new([1, 2])
      deque.pop_back
      deque.pop_back
      deque.pop_back.should be_nil
      deque.back.should be_nil
      deque.pop_front.should be_nil
      deque.front.should be_nil
    end
  end
end
