-- ENTITY --
-- entity with position, velocity and sprites
class Entity
	-- create a new entity with list of sprites
	new: (pos, sprites, w, h, chroma, shadow) =>
		-- physics
		@pos = Vector.clone pos
		@vel = Vector.zero!
		@acc = Vector.zero!
		-- rendering
		@sprites, @sprite_index, @flip = sprites, 1, false
		@w = w or 1 
		@h = h or @w
		@chroma, @shadow = chroma or -1, shadow

	-- apply velocity and acceleration to entity
	update:=>
		@pos += @vel
		@vel += @acc
		return @
	
	-- display a shadow at the given position
	castShadow: (x, y) =>
		if @shadow
			x -= @w * 4
			y -= 4
			spr @shadow, x, y, 15, 1, 0, 0, @w, 1
		return @

	castShadowS: (x, y, s) =>
		UTIL.ellipse x, y, @w*8*s, @h*3*s, 0
		return @

	-- basic print of the sprite without scaling
	render: (x, y) =>
		x -= @w * 4
		y -= @h * 4
		-- we may need to flip the sprite
		id = @sprites[@sprite_index]
		flip = if @flip then 1 else 0
		spr id, x, y, @chroma, 1, flip, 0, @w, @h
		return @
	
	-- print the sprite with scaling
	-- (the sprite may not be clean)
	renderS: (x, y, s) =>
		id = @sprites[@sprite_index]
		flip = if @flip then 1 else 0
		UTIL\spr_x id, x, y, @chroma, s, flip, @w, @h
		return @

-- END ENTITY --


