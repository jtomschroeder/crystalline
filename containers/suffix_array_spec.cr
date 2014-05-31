
require "spec"
require "suffix_array"

describe "SuffixArray" do
  it "should not initialize with empty string" do
    begin
      SuffixArray.new("")
      fail "new() should have raised an exception"
    rescue
    end
  end

  it "should has_substring? each possible substring" do
    suffix_array = SuffixArray.new("abracadabra")
    suffix_array.has_substring?("a").should be_true
    suffix_array.has_substring?("abra").should be_true
    suffix_array.has_substring?("abracadabra").should be_true
    suffix_array.has_substring?("acadabra").should be_true
    suffix_array.has_substring?("adabra").should be_true
    suffix_array.has_substring?("bra").should be_true
    suffix_array.has_substring?("bracadabra").should be_true
    suffix_array.has_substring?("cadabra").should be_true
    suffix_array.has_substring?("dabra").should be_true
    suffix_array.has_substring?("ra").should be_true
    suffix_array.has_substring?("racadabra").should be_true
  end

  it "should not has_substring? substrings it does not have" do
    suffix_array = SuffixArray.new("abracadabra")
    suffix_array.has_substring?("nope").should be_false
    suffix_array.has_substring?("").should be_false
  end
end
