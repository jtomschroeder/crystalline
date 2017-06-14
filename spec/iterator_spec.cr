require "spec"
require "../graph/iterator"

def new_collection_iterator
  CollectionIterator(Int32).new(1..5)
end

describe "Iterator" do
  it "enumerable" do
    s = new_collection_iterator
    s.map { |x| x * 2 }.to_a.should eq [2, 4, 6, 8, 10]
    s.select { |x| x % 2 == 0 }.should eq [2, 4]
  end

  it "collection_Iterator" do
    s = new_collection_iterator
    s.to_a.should eq [1, 2, 3, 4, 5]
    s.at_end?.should be_true
    expect_raises(AbstractIterator::EndOfIteratorException) { s.forward }
    s.backward.should eq 5
    s.forward.should eq 5
    s.current.should eq 5
    s.peek.should eq s

    s.set_to_begin
    s.at_beginning?.should be_true
    expect_raises(AbstractIterator::EndOfIteratorException) { s.backward }
    s.current.should eq s
    s.peek.should eq 1
    s.forward.should eq 1
    s.current.should eq 1
    s.peek.should eq 2

    s.move_forward_until { |x| x > 3 }.should eq 4
    s.move_forward_until { |x| x < 3 }.should eq nil
    s.at_end?.should be_true

    s.set_to_begin
    s.move_forward_until { |x| x > 6 }.should eq nil

    s.set_to_end
    s.move_backward_until { |x| x < 2 }.should eq 1
    s.move_backward_until { |x| x < 0 }.should eq nil
  end
end
