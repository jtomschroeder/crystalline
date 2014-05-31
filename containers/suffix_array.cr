
class SuffixArray
  def initialize(string : String)
    raise("Suffix array cannot be initialized with an empty string.") if string.empty?
    @suffixes = [] of String
    string.length.times { |i| @suffixes << string[i..-1] }
    @suffixes.sort!
  end

  def has_substring?(substring : String)
    return false if substring.empty?
    substring_length = substring.length - 1
    l, r = 0, @suffixes.size - 1
    until l > r
      mid = (l + r) / 2
      suffix = @suffixes[mid][0..substring_length]
      case Math.max(-1, Math.min(1, substring <=> suffix)) # bound <=> to -1, 0, 1
        when  0
          return true
        when  1
          l = mid + 1
        when -1
          r = mid - 1
      end
    end
    return false
  end

  def [](substring)
    has_substring?(substring)
  end
end
