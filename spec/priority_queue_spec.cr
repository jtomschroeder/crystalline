
require "../containers/priority_queue"
require "spec"

def setup
  pq = PriorityQueue(String).new
  pq.push("Alaska", 50)
  pq.push("Delaware", 30)
  pq.push("Georgia", 35)
  pq
end

describe "PriorityQueue" do
  
  describe "(empty priority queue)" do
    it "should return 0 for size and be empty" do
      pq = PriorityQueue(Int32).new
      pq.size.should eq(0)
      pq.empty?.should be_true
    end
    
    it "should not return anything" do
      pq = PriorityQueue(Int32).new
      pq.next.should be_nil
      pq.pop.should be_nil
      pq.delete(1).should be_nil
      pq.has_priority?(1).should be_false
    end
    
    it "should give the correct size when adding items" do
      pq = PriorityQueue(Int32).new
      20.times do |i|
        pq.size.should eq(i)
        pq.push(i, i)
      end
      10.times do |i|
        pq.size.should eq(20-i)
        pq.pop
      end
      10.times do |i|
        pq.size.should eq(i+10)
        pq.push(i, i)
      end
      pq.delete(5)
      pq.size.should eq(19)
    end
  end
  
  describe "(non-empty priority queue)" do
    
    it "should next/pop the highest priority" do
      pq = setup
      pq.next.should eq("Alaska")
      pq.size.should eq(3)
      pq.pop.should eq("Alaska")
      pq.size.should eq(2)
    end
    
    it "should not be empty" do
      pq = setup
      pq.empty?.should be_false
    end
    
    it "should has_priority? priorities it has" do
      pq = setup
      pq.has_priority?(50).should be_true
      pq.has_priority?(10).should be_false
    end      
    
    it "should return nil after popping everything" do
      pq = setup
      3.times do 
        pq.pop
      end
      pq.pop.should be_nil
    end
    
    it "should delete things it has and not things it doesn't" do
      pq = setup
      pq.delete(50).should eq("Alaska")
      pq.delete(10).should eq(nil)
    end
  end
end
