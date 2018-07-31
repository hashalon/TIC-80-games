
-- a block of a given material
class Block
	new:(p1,p2,mat)=>
        -- make so that p1 is the minimal point and p2 the maximal point
		@p1,@p2 = Vector3\min(p1, p2), Vector3\max(p1, p2)
        @mat = mat

	-- generate a platform given the direction
	-- 1: x-> z^
    -- 2: xv  z->
    -- 3: x<- zv
    -- 4: x^  z<-
	makePlatform:(dir)=>
		switch dir
            when 1 then return Platform @p1.x, @p2.x, @p2.y, @p1.y, -@p1.z
            when 2 then return Platform @p1.z, @p2.z, @p2.y, @p1.y,  @p2.x
            when 3 then return Platform @p1.x, @p2.x, @p2.y, @p1.y,  @p2.z
            when 4 then return Platform @p1.z, @p2.z, @p2.y, @p1.y, -@p1.x


-- decrepated
    -- project the block on the grid if permitted
    -- 1: u = +x | w = -z
    -- 2: u = +z | w = +x
    -- 3: u = -x | w = +z
    -- 4: u = -z | w = -x
    project:(dir, grid)=>
        -- get dimensions of the block relative to the grid
        local u1,v1,u2,v2, w
        if     dir==1 or dir==3 then u1,u2 = @p1.x, @p2.x
        elseif dir==2 or dir==4 then u1,u2 = @p1.z, @p2.z
        switch dir
            when 1 then w = -@p1.z
            when 2 then w =  @p2.x
            when 3 then w =  @p2.z
            when 4 then w = -@p1.x
        v1,v2 = @p1.y, @p2.y

        -- for each cell of the block see if we can project it
        for j = v1, v2
            for i = u1, u2
                c = grid[j][i]
                -- nothing yet or current is closer? => project
                if c == nil or w > c.depth
                    grid[j][i] = {depth: w, mat: @mat}
        return -- end
