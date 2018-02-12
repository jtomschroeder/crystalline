module Algorithms::Search
  def self.kmp_table(patt : String)
    tbl = Array.new(patt.size + 1, -1)
    k = -1
    i = 1
    while i <= patt.size
      while k >= 0 && patt[k] != patt[i-1]
        k = tbl[k]
      end
      k += 1
      tbl[i] = k
      i += 1
    end
    tbl
  end

  def self.kmp_search(text : String, patt : String)
    return nil unless text && patt
    matches = [] of Int32
    k = 0
    i = 1
    tbl = kmp_table(patt)
    while i <= text.size
      while k >= 0 && patt[k] != text[i-1]
        k = tbl[k]
      end
      k += 1
      if k == patt.size
        matches << i - patt.size
        k = tbl[k]
      end
      i += 1
    end
    matches
  end
end
