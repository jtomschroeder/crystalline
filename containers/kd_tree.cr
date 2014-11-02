
class KDTree(T)

  class Node
    property :id, :coords, :left, :right

    def initialize(@id : T, @coords : Array(T), @left = nil, @right = nil)
      @id :: T
    end
  end
  
  def initialize(points : Hash(T, Array(T)))
    @dimensions = points[points.keys.first].size
    @root = build_tree(points.to_a)
    @nearest = [] of Array(T)
  end
  
  # Find k closest points to given coordinates 
  def find_nearest(target : Array(T), k_nearest : Int32)
    @nearest = [] of Array(T)
    if root = @root
      nearest(root, target, k_nearest, 0)
    end
  end
  
  def build_tree(points : Array({T, Array(T)}), depth = 0)
    return if points.empty?
    
    axis = depth % @dimensions
    
    points.sort! { |a, b| a[1][axis] <=> b[1][axis] }
    median = points.size / 2
    
    node = Node.new(points[median][0], points[median][1])
    node.left = build_tree(points[0...median], depth + 1)
    node.right = build_tree(points[median + 1..-1], depth + 1)
    node
  end

  # Euclidian distance, squared, between a node and target coords
  private def distance2(node, target)
    return unless node && target
    c = node.coords[0] - target[0]
    d = node.coords[1] - target[1]
    c * c + d * d
  end

  # Update array of nearest elements if necessary
  private def check_nearest(nearest, node, target, k_nearest)
    d = distance2(node, target) as T
    if nearest.size < k_nearest || d < nearest.last[0]
      nearest.pop if nearest.size >= k_nearest
      nearest << [d, node.id]
      nearest.sort! { |a, b| a[0] <=> b[0] }
    end
    nearest
  end

  # Recursively find nearest coordinates, going down the appropriate branch as needed
  private def nearest(node : Node?, target, k_nearest, depth)
    axis = depth % @dimensions
  
    if node
      unless node.left || node.right # Leaf node
        @nearest = check_nearest(@nearest, node, target, k_nearest)
        return
      end
    
      # Go down the nearest split
      if !node.right || (node.left && target[axis] <= node.coords[axis])
        nearer = node.left
        further = node.right
      else
        nearer = node.right
        further = node.left
      end
      nearest(nearer, target, k_nearest, depth + 1)
    
      # See if we have to check other side
      if further
        if @nearest.size < k_nearest || (target[axis] - node.coords[axis]) ** 2 < @nearest.last[0]
          nearest(further, target, k_nearest, depth + 1)
        end
      end
    
      @nearest = check_nearest(@nearest, node, target, k_nearest)
    end
  end
  
end
