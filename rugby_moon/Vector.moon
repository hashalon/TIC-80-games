-- VECTOR --
-- vector 3D to do math
class Vector
	-- create a new vector
	new: (x, y, z) => @x, @y, @z = x, y, z

	-- make a copy of the vector
    clone:=> @@ @x,@y,@z
	copy: (v) =>
		@x, @y, @z = v.x, v.y, v.z
		return @

	-- apply to vector
	scale: (s) =>
		@x *= s
		@y *= s
		@z *= s
		return @

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

    __tostring:=> "Vector(#{@x}, #{@y}, #{@z})"
	
	-- basic vector operations
	__add: (v) => @@ @x + v.x, @y + v.y, @z + v.z
	__sub: (v) => @@ @x - v.x, @y - v.y, @z - v.z
	__mul: (c) => @@ @x * c  , @y * c  , @z * c

	__unm:=> @@ -@x, -@y, -@z
    __len:=> math.sqrt @sqrMag!

    __eq:(v)=> @x == v.x and @y == v.y and @z == v.z

    __index:(i)=> switch i
        when 1 then return @x
        when 2 then return @y
        when 3 then return @z
	
	-- vector operations
	@dot:   (u, v) -> u.x * v.x + u.y * v.y + u.z * v.z
	@cross: (u, v) -> @@(
		u.y * v.z - u.z * v.y,
		u.z * v.x - u.x * v.z,
		u.x * v.y - u.y * v.x)

	-- return a new null vector
	@zero:-> @@(0, 0, 0)

-- END VECTOR --


