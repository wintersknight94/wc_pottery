-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
-- ================================================================== --
local potsoil	= "nc_tree_humus.png"
local ceramic	= modname.. "_ceramic.png"
local ceraform	= ceramic.. "^[mask:nc_api_storebox_frame.png"
local cerasoil	= "(" ..potsoil.. ")^(" ..ceraform.. ")"
------------------------------------------------------------------------
local glaze	= modname.. "_glaze.png"
local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
local glazform	= "nc_api_storebox_frame.png^[opacity:40"
local glazcera	= "(" ..ceramic.. ")^(" ..glaze.. ")"
local glazside	= "(" ..glazcera.. ")^(" ..glazpatt.. ")"
local glazetop	= "(" ..glazcera.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
local glazsoil	= "(" ..potsoil.. ")^(" ..glazetop.. ")"
-- ================================================================== --
minetest.register_node(modname .. ":pottery_flowerpot", {
	description = "Ceramic Flowerpot",
	tiles = {
		cerasoil,
		ceramic,
		ceramic
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		soil = 4,
		cracky = 2,
		totable = 1,
		flowerpot = 1,
		scaling_time = 150
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_flowerpot_glazed", {
	description = "Glazed Ceramic Flowerpot",
	tiles = {
		glazsoil,
		glazcera,
		glazside
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		soil = 4,
		cracky = 3,
		totable = 1,
		flowerpot = 1,
		scaling_time = 200,
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy")
})
-- ================================================================== --
nodecore.register_craft({
		label = "fill ceramic pot with compost",
		action = "stackapply",
		indexkeys = {modname.. ":pottery_claypot"},
		wield = {groups = {humus = true}},
		consumewield = 1,
		nodes = {
			{
				match = {name = modname.. ":pottery_claypot", empty = true},
				replace = modname .. ":pottery_flowerpot"
			},
		}
	})
------------------------------------------------------------------------
nodecore.register_craft({
		label = "fill glazed ceramic pot with compost",
		action = "stackapply",
		indexkeys = {modname.. ":pottery_claypot_glazed"},
		wield = {groups = {humus = true}},
		consumewield = 1,
		nodes = {
			{
				match = {name = modname.. ":pottery_claypot_glazed", empty = true},
				replace = modname .. ":pottery_flowerpot_glazed"
			},
		}
	})
-- ================================================================== --
nodecore.register_craft({
	label = "empty ceramic flowerpot",
	action = "pummel",
	indexkeys = {modname.. ":pottery_flowerpot"},
	nodes = {
		{match = {name = modname.. ":pottery_flowerpot"}, 
		replace = modname.. ":pottery_claypot"}
	},
	items = {
		{name = "nc_tree:humus_loose", count = 1, scatter = 1},
	},
	toolgroups = {crumbly = 2},
	itemscatter = 1
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "empty glazed ceramic flowerpot",
	action = "pummel",
	indexkeys = {modname.. ":pottery_flowerpot_glazed"},
	nodes = {
		{match = {name = modname.. ":pottery_flowerpot_glazed"}, 
		replace = modname.. ":pottery_claypot_glazed"}
	},
	items = {
		{name = "nc_tree:humus_loose", count = 1, scatter = 1},
	},
	toolgroups = {crumbly = 2},
	itemscatter = 1
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "break ceramic flowerpot apart",
	action = "pummel",
	indexkeys = {"group:flowerpot"},
	nodes = {{match = {groups = {flowerpot = true}}, replace = "nc_tree:humus_loose"}},
	items = {{name = modname .. ":chip", count = 8, scatter = 5}},
	toolgroups = {cracky = 3, thumpy = 4},
	itemscatter = 5
})
-- ================================================================== --