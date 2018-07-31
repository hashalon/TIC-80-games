
-- a map made of blocks
class Map
    new:=>
        @blocks = {}
        @sides  = {} -- contains sets of platforms

    -- add a block to the map
    add:(b)=> @blocks[b] = true

    -- return the full dimensions of the map
    dim:=>
        @min, @max = Vector3(MAX,MAX,MAX), Vector3(MIN,MIN,MIN)
        for b in pairs @blocks
            @min = Vector3\min(@min, b.p1)
            @max = Vector3\max(@max, b.p2)
        @min, @max


    -- generate the physics platform for the given orientation
    -- 1: x-> z^
    -- 2: xv  z->
    -- 3: x<- zv
    -- 4: x^  z<-
    initPlatforms:(dir)=>
        -- generate platforms
        plts, cnt = {}, 0
        for b in pairs @blocks
            plts[cnt + 1] = b\makePlatform dir
            cnt += 1

        -- sort the platforms based on depth
        table.sort(plts, (l,r)-> l.depth < r.depth)

        -- from back to front cut platforms
        set = {}
        for i = cnt, 1, -1
            p1 = plts[i] -- new platform
            -- see if it is occluding previous platforms
            for p2 in pairs set
                r = p2\cut p1
                if     r ==  -1 then set[p2] = nil
                elseif r ~= nil then set[r]  = true
            set[p1] = true
        
        -- store the set of platforms
        @sides[dir] = set
        set




-- decrepated...
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
