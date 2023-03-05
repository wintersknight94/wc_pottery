-- LUALOCALS < ---------------------------------------------------------
local include, minetest, nodecore, pairs, vector
    = include, minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end
------------------------------------------------------------------------
local clay = "nc_terrain_dirt.png^[colorize:tan:100"
local claydirt = "nc_terrain_dirt.png^[colorize:tan:25"
local claysand = "nc_terrain_sand.png^[colorize:tan:100"
local claylump = "(" ..clay.. ")^[mask:nc_fire_lump.png"
-- ================================================================== --
minetest.register_craftitem(modname .. ":lump_clay", {
	description = "Clay Lump",
	inventory_image = claylump,
	sounds = nodecore.sounds("nc_terrain_chompy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":dirt_with_clay", {
	description = "Clay Dirt",
	tiles = {claydirt},
	groups = {
		crumbly = 1,
		soil = 1,
		dirt = 1,
		claydirt = 1,
		grassable = 1
	},
	alternate_loose = {
		tiles = {"(" ..claydirt.. ")^nc_api_loose.png"},
		groups = {
			crumbly = 1,
			soil = 2,
			dirt_loose = 2,
			falling_repose = 2,
		}
	},
	sounds = nodecore.sounds("nc_terrain_chompy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":sand_with_clay", {
	description = "Sandy Clay",
	tiles = {claysand},
	groups = {
		crumbly = 1,
		sand = 1,
		claysand = 1,
		falling_node = 1
	},
	alternate_loose = {
		tiles = {"(" ..claysand.. ")^nc_api_loose.png"},
		groups = {
			sand_loose = 2,
			falling_repose = 1,
		}
	},
	sounds = nodecore.sounds("nc_terrain_swishy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":clay", {
	description = "Clay",
	tiles = {clay},
	groups = {
		clay = 1,
		soil = 1,
		crumbly = 1,
		falling_repose = 2,
		slippery = 1
	},
	sounds = nodecore.sounds("nc_terrain_chompy")
})
-- ================================================================== --
nodecore.register_craft({
	label = "extract clay from clay dirt",
	action = "pummel",
	indexkeys = {"group:claydirt"},
	nodes = {
		{match = {groups = {claydirt = true}}, 
		replace = "nc_terrain:dirt_loose"}
	},
	items = {
		{name = modname.. ":lump_clay", count = 1, scatter = 2},
	},
	toolgroups = {crumbly = 2},
	itemscatter = 2
})
nodecore.register_craft({
	label = "extract clay from sandy clay",
	action = "pummel",
	indexkeys = {"group:claysand"},
	nodes = {
		{match = {groups = {claysand= true}}, 
		replace = "nc_terrain:sand_loose"}
	},
	items = {
		{name = modname.. ":lump_clay", count = 1, scatter = 2},
	},
	toolgroups = {crumbly = 2},
	itemscatter = 2
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "compress clay block",
	action = "pummel",
	toolgroups = {thumpy = 1},
	indexkeys = {modname .. ":lump_clay"},
	nodes = {
		{
			match = {name = modname .. ":lump_clay", count = 8},
			replace = modname .. ":clay"
		}
	}
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "break clay apart",
	action = "pummel",
	indexkeys = {modname.. ":clay"},
	nodes = {
		{match = modname.. ":clay", replace = "air"}
	},
	items = {
		{name = modname.. ":lump_clay", count = 8, scatter = 3},
	},
	toolgroups = {crumbly = 2},
	itemscatter = 3
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "mix clay into dirt",
	action = "pummel",
	priority = 1,
	wield = {name = modname.. ":lump_clay"},
	after = rfcall,
	nodes = {
		{
			match = "nc_terrain:dirt_loose",
			replace = modname .. ":dirt_with_clay_loose"
		}
	}
})
nodecore.register_craft({
	label = "mix clay into sand",
	action = "pummel",
	priority = 1,
	wield = {name = modname.. ":lump_clay"},
	after = rfcall,
	nodes = {
		{
			match = "nc_terrain:sand_loose",
			replace = modname .. ":sand_with_clay_loose"
		}
	}
})
-- ================================================================== --
minetest.register_ore({
	ore_type = "blob",
	ore  = modname.. ":dirt_with_clay",
	wherein = {"group:dirt"},
	clust_scarcity = 16 * 16 * 16,
	clust_size = 12,
	noise_threshold = 0.25,
	noise_params = {
		offset = 0.5,
		scale = 0.25,
		spread = {x = 8, y = 8, z = 8},
		seed = 1294,
		octaves = 1,
		persist = 0.0
	},
})
------------------------------------------------------------------------
minetest.register_ore({
	ore_type = "blob",
	ore  = modname.. ":sand_with_clay",
	wherein = {"group:sand"},
	clust_scarcity = 16 * 16 * 16,
	clust_size = 12,
	y_max = 1,
	noise_threshold = 0.25,
	noise_params = {
		offset = 0.5,
		scale = 0.25,
		spread = {x = 8, y = 8, z = 8},
		seed = 1220,
		octaves = 1,
		persist = 0.0,
		flags = "eased",
	}
})
-- ================================================================== --
