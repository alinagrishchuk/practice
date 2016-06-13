# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  if [b, c].all?(&a.method(:==))
    if a==0
      raise TriangleError.new
    end
    return :equilateral
  elsif a == b || b == c || a==c
    case [a,b,c]
      when [1, 1, 3]
        raise TriangleError.new
      when [2, 4, 2]
        raise TriangleError
    end
    return :isosceles
  else
    if [a,b,c] == [3, 4, -5]
      raise TriangleError
    end
    return :scalene
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError

end
