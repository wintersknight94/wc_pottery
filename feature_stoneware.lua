-- LUALOCALS < ---------------------------------------------------------
local include, minetest, nodecore, pairs, vector
    = include, minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end
------------------------------------------------------------------------
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end
-- ================================================================== --
local form		= "nc_tree_tree_side.png^[mask:nc_api_storebox_frame.png"
local ceramic	= modname.. "_ceramic.png^[colorize:black:128"
local ceraform	= ceramic.. "^[mask:nc_api_storebox_frame.png"
local glaze	= modname.. "_glaze.png"
local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
local glazform	= "nc_api_storebox_frame.png^[opacity:40"
local glazcera	= "(" ..ceramic.. ")^(" ..glaze.. ")"
local glazside	= "(" ..glazcera.. ")^(" ..glazpatt.. ")"
local glazetop	= "(" ..glazcera.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
-- ================================================================== --
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_stoneware_pot", {
	description = "Stoneware Pot",
	tiles = {
		ceramic,
		ceramic,
		ceraform
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 3,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 150,
		ceramic = 2,
		falling_node = 1,
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_stoneware_pot_glazed", {
	description = "Glazed Stoneware Pot",
	tiles = {
		glazside,
		glazcera,
		glazetop
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 4,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 200,
		ceramic = 3,
		falling_node = 1,
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
-- ================================================================== --
------------------------------------------------------------------------
nodecore.register_craft({
	label = "fire stoneware pot",
	action = "cook",
	touchgroups = {flame = 4},
	neargroups = {coolant = 0},
	priority = 2,
	duration = 30,
	cookfx = true,
	indexkeys = {modname.. ":pottery_claypot_unfired"},
	nodes = {
		{
			match = {name = modname.. ":pottery_claypot_unfired", empty = true},
			replace = modname .. ":pottery_stoneware_pot"
		}
	}
})
nodecore.register_cook_abm({nodenames = {modname.. ":pottery_claypot_unfired"}, neighbors = {"group:flame"}})
nodecore.register_cook_abm({nodenames = {modname .. ":pottery_stoneware_pot"}})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "glaze stoneware pot",
	action = "pummel",
	wield = {name = "nc_tree:eggcorn"},
	after = rfcall,
	nodes = {
		{
			match = {name = modname.. ":pottery_stoneware_pot", empty = true},
			replace = modname .. ":pottery_stoneware_pot_glazed"
		}
	}
})
------------------------------------------------------------------------
if minetest.get_modpath("wc_noditions") then
	nodecore.register_craft({
		label = "glaze stoneware pot with resin",
		action = "pummel",
		wield = {name = "wc_noditions:lump_sap"},
		after = rfcall,
		nodes = {
			{
				match = {name = modname.. ":pottery_stoneware_pot", empty = true},
				replace = modname .. ":pottery_stoneware_pot_glazed"
			}
		}
	})
end
-- ================================================================== --

------------------------------------------------------------------------
