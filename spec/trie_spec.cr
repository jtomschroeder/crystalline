
require "spec"
require "../containers/trie"

def setup_trie
  trie = Trie.new
  trie.push("Hello", "World")
  trie.push("Hilly", "World")
  trie.push("Hello, brother", "World")
  trie.push("Hello, bob", "World")
  trie
end
    
describe "Trie" do
  describe "(empty)" do
    it "should not get or has_key?" do
      trie = Trie.new
      trie.get("anything").should be_nil
      trie.has_key?("anything").should be_false
    end

    it "should not have longest_prefix or match wildcards" do
      trie = Trie.new
      trie.wildcard("an*thing").should eq([] of String)
      trie.longest_prefix("an*thing").should eq("")
    end

    it "should handle empty strings" do
      trie = Trie.new
      trie.push("", "").should be_nil
      trie.get("").should be_nil
      trie.has_key?("").should be_false
      trie.longest_prefix("").should eq("")
    end
  end

  describe "(non-empty)" do
    it "should has_key? keys it has" do
      trie = setup_trie()
      trie.has_key?("Hello").should be_true
      trie.has_key?("Hello, brother").should be_true
      trie.has_key?("Hello, bob").should be_true
    end

    it "should not has_key? keys it doesn't have" do
      trie = setup_trie()
      trie.has_key?("Nope").should be_false
    end

    it "should get values" do
      trie = setup_trie()
      trie.get("Hello").should eq("World")
    end

    it "should handle empty strings" do
      trie = Trie.new
      trie.push("", "").should be_nil
      trie.get("").should be_nil
      trie.has_key?("").should be_false
      trie.longest_prefix("").should eq("")
    end

    it "should overwrite values" do
      trie = setup_trie()
      trie.push("Hello", "John")
      trie.get("Hello").should eq("John")
    end

    it "should return longest prefix" do
      trie = setup_trie()
      trie.longest_prefix("Hello, brandon").should eq("Hello")
      trie.longest_prefix("Hel").should eq("")
      trie.longest_prefix("Hello").should eq("Hello")
      trie.longest_prefix("Hello, bob").should eq("Hello, bob")
    end

    it "should match wildcards" do
      trie = setup_trie()
      trie.wildcard("H*ll.").should eq(["Hello", "Hilly"])
      trie.wildcard("Hel").should eq([] of String)
    end
  end
end
