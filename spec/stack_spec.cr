#!/usr/bin/env bin/crystal --run

require "spec"
require "../containers/stack"

describe "Stack" do
  describe "(empty)" do
    it "should return nil when sent #pop" do
      stack = Stack(Int32).new
      stack.pop.should be_nil
    end

    it "should return a size of 1 when sent #push" do
      stack = Stack(Int32).new
      stack.push(1)
      stack.size.should eq(1)
    end

    it "should return nil when sent #next" do
      stack = Stack(Int32).new
      stack.next.should be_nil
    end

    it "should return empty?" do
      stack = Stack(Int32).new
      stack.empty?.should be_true
    end
  end

  describe "(non-empty)" do
    it "should return last pushed object" do
      stack = Stack(Int32).new([1, 2, 3, 5, 8])
      stack.pop.should eq(8)
    end

    it "should return the size" do
      stack = Stack(Int32).new([1, 2, 3, 5, 8])
      stack.size.should eq(5)
    end

    it "should not return empty?" do
      stack = Stack(Int32).new([1, 2, 3, 5, 8])
      stack.empty?.should be_false
    end


    it "should iterate in LIFO order" do
      stack = Stack(Int32).new([1, 2, 3, 5, 8])
      arr = [] of Int32
      stack.each { |obj| arr << obj }
      arr.should eq([8, 5, 3, 2, 1])
    end

    it "should return nil after all pops" do
      stack = Stack(Int32).new([1, 2, 3, 5, 8])
      5.times { stack.pop }
      stack.pop.should be_nil
      stack.next.should be_nil
    end
  end
end
