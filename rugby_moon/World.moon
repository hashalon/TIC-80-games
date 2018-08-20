-- WORLD --
-- contains characters and objects
class World
	-- create a world with a list of entities
	new: (n_players) =>
		@entities, @ordered = {}, {} -- entities in the world
		@players = {} -- players that can interact with the world
		for i = 1, n_players
			@players[i] = Player i-1

	-- update our entities
	update:=>
		for e, _ in pairs @entities
			e\update!
		return

	-- manage entities
	add: (e) => 
		@entities[e] = true
		table.insert @ordered, e
	remove: (e) => 
		-- check that the entity is actually in the list
		if @entities[e]
			-- iterate the ordered list and remove the element
			for i, f in pairs @ordered
				if f == e then table.remove @ordered, i
			@entities[e] = nil
		return

	-- return the height of the ground
	ground: (x,z) => PROPS.ground

	-- render the world using the camera
	orderEntities:=>
		-- sort the list of object from farest to closest
		table.sort(@ordered, (a, b) -> a.pos.z > b.pos.z)
		return @ordered

-- END WORLD --


