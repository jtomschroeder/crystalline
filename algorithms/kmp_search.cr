module Algorithms::Search
  private def self.kmp_table(patt : String)
    tbl = Array.new(patt.size + 1, -1)
    k = -1
    (1..patt.size).each do |i|
      while k >= 0 && patt[k] != patt[i-1]
        k = tbl[k]
      end
      k += 1
      tbl[i] = k
    end
    tbl
  end

  def self.kmp_search(text : String, patt : String)
    return nil unless text && patt
    matches = [] of Int32
    k = 0
    tbl = kmp_table(patt)
    (1..text.size).each do |i|
      while k >= 0 && patt[k] != text[i-1]
        k = tbl[k]
      end
      k += 1
      if k == patt.size
        matches << i - patt.size
        k = tbl[k]
      end
    end
    matches
  end
end
