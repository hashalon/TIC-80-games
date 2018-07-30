-- Vector3
-- defined in a left-handed coordinate system

-- a point in 3D space
class Vector3
	new:(x,y,z)=>
		@x,@y,@z = x,y,z

    -- SIMPLE METHODS

    -- make a copy of the vector
    clone:=> @@ @x,@y,@z

    -- scale the vector itself
    scale:(s)=>
        @x *= s
        @y *= s
        @z *= s

    -- faster to compute
    sqrMag:=> @x * @x + @y * @y + @z * @z

    -- magnitude of the vector
    magnitude:=> math.sqrt @sqrMag!

    -- normalize the vector s.t. its length is 1
    normalize:=>
        s = @sqrMag!
        if s == 1 then return @
        m = math.sqrt s
        @x /= m
        @y /= m
        @z /= m
        @

    -- OPERATORS

    __tostring:=> "Vector(#{@x}, #{@y}, #{@z})"

    __add:(v)=> @@ @x+v.x, @y+v.y, @z+v.z
    __sub:(v)=> @@ @x-v.x, @y-v.y, @z-v.z
    __mul:(s)=> @@ @x*s, @y*s, @z*s

    __unm:=> @@ -@x, -@y, -@z
    __len:=> math.sqrt @sqrMag!

    __eq:(v)=> @x == v.x and @y == v.y and @z == v.z

    __index:(i)=> switch i
        when 1 then return @x
        when 2 then return @y
        when 3 then return @z

    -- STATIC FUNCTIONS

    -- return a vector with minimal value from both vectors
    @min:(a,b)=> Vector3(
        math.min(a.x, b.x),
        math.min(a.y, b.y),
        math.min(a.z, b.z))

    @max:(a,b)=> Vector3(
        math.max(a.x, b.x),
        math.max(a.y, b.y),
        math.max(a.z, b.z))


    -- sum of products, member per member
    @dot:(a,b)=> a.x * b.x + a.y * b.y + a.z * b.z

    -- given vectors a,b and coords i,j,k
    -- compute the determinant of the following matrix
    -- | i  j  k  |
    -- | a1 a2 a3 |
    -- | b1 b2 b3 |
    @cross:(a,b)=> return @@(
            a.y * b.z - a.z * b.y,
            a.x * b.z - a.z * b.x,
            a.x * b.y - a.y * b.z)

    -- rotate around the axis (1:x, 2:y, 3:z)
    @rotate:(vec, ang, axis)=>
        switch axis
            when 1
                u,v = @rotVec2 vec.z, vec.y, ang
                return @ vec.x, v, u
            when 2
                u,v = @rotVec2 vec.x, vec.z, ang
                return @ u, vec.y, v
            when 3
                u,v = @rotVec2 vec.y, vec.x, ang
                return @ v, u, vec.z

    -- helper function to rotate a 2D vector
    @rotVec2:(u,v,a)=> math.cos(a * u) - math.sin(a * v), math.sin(a * u) + math.cos(a * v)
