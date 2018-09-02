module Crystalline
  module Algorithms::Search
    def self.binary_search(container, item)
      return nil unless item

      low = 0
      high = container.size - 1
      while low <= high
        mid = (low + high) / 2
        if container[mid] < item
          low = mid + 1
        elsif container[mid] > item
          high = mid - 1
        else
          return mid
        end
      end
      nil
    end
  end
end
