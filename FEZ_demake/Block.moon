
-- a map made of blocks
class Map
    new:=>
        @blocks = {}

    -- add a block to the map
    add:(b)=> @blocks[b] = true

    -- return the full dimensions of the map
    dim:=>
        @min, @max = Vector3(MAX,MAX,MAX), Vector3(MIN,MIN,MIN)
        for b in pairs @blocks
            @min = Vector3\min(@min, b.p1)
            @max = Vector3\max(@max, b.p2)
        @min, @max

    -- project the map given one orientation s.t. it can be rendered
    -- 1: x-> z^
    -- 2: xv  z->
    -- 3: x<- zv
    -- 4: x^  z<-
    project:(dir)=>
        -- compute the dimensions of the map
        if @min == nil or @max == nil then @dim!

        -- find which component to use: either x or z
        start, stop = {v: @min.y}, {v: @max.y}
        if     dir==1 or dir==3 then start.u, stop.u = @min.x, @max.x
        elseif dir==2 or dir==4 then start.u, stop.u = @min.z, @max.z

        -- build the grid vertically
        grid =
            start: start
            stop:  stop

        -- we can choose indexes anywhere we want
        -- the only drawback is that the '#' operator cannot be used
        for i = @min.y, @max.y do grid[i] = {}

        -- for each block, project it into the grid
        for b in pairs @blocks do b\project dir, grid

        -- TODO: add more info in the grid: material, tile to use, collisions
        for j = start.v, stop.v
            for i = start.u, stop.u
                -- get current tile and surrounding ones
                c   = grid[j][i]
                u,d = grid[j+1][i], grid[j-1][i]
                l,r = grid[j][i-1], grid[j][i+1]

                -- deduce tile to use



        -- return the grid built to render it
        return grid


-- a block of a given material
class Block
	new:(p1,p2,mat)=>
        -- make so that p1 is the minimal point and p2 the maximal point
		@p1,@p2 = Vector3\min(p1, p2), Vector3\max(p1, p2)
        @mat = mat

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
