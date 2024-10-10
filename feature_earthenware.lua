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
local hard	=	"nc_concrete_adobe.png"
local form	=	"nc_tree_tree_side.png^[mask:nc_api_storebox_frame.png"
local soft	=	hard.. "^(nc_concrete_pliant.png^[opacity:100)"
------------------------------------------------------------------------
local softform	= "(" ..soft.. ")^(" ..form.. ")"
local hardform	= hard.. "^[mask:nc_api_storebox_frame.png"
------------------------------------------------------------------------
local glaze	= modname.. "_glaze.png"
local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
local glazform	= "nc_api_storebox_frame.png^[opacity:40"
local glazhard	= "(" ..hard.. ")^(" ..glaze.. ")"
local glazside	= "(" ..glazhard.. ")^(" ..glazpatt.. ")"
local glazetop	= "(" ..glazhard.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
-- ================================================================== --
minetest.register_node(modname .. ":pottery_adobe_pot_unfired", {
	description = "Unfired Earthenware Pot",
	tiles = {
		softform,
		softform,
		form
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		snappy = 1,
		visinv = 1,
		storebox = 1,
		scaling_time = 180,
		unfired_clay = 1,
		flammable = 40,
		fire_fuel = 2,
		falling_node = 1
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_tree_woody"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_earthenware_pot", {
	description = "Earthenware Pot",
	tiles = {
		hard,
		hard,
		hardform
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		snappy = 1,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 150,
		earthenware = 2,
		falling_node = 1,
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_earthenware_pot_glazed", {
	description = "Glazed Earthenware Pot",
	tiles = {
		glazside,
		glazhard,
		glazetop
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 2,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 200,
		earthenware = 3,
		falling_node = 1,
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
-- ================================================================== --
nodecore.register_craft({
	label = "form pliant adobe",
	action = "pummel",
	wield = {name = "nc_woodwork:form"},
	after = rfcall,
	nodes = {
		{match = "nc_concrete:concrete_adobe_blank_ply", replace = modname .. ":pottery_adobe_pot_unfired"}
	}
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "fire earthenware pot",
	action = "cook",
	touchgroups = {flame = 2},
	neargroups = {coolant = 0},
	duration = 30,
	cookfx = true,
	indexkeys = {modname.. ":pottery_adobe_pot_unfired"},
	nodes = {
		{
			match = {name = modname.. ":pottery_adobe_pot_unfired", empty = true},
			replace = modname .. ":pottery_earthenware_pot"
		}
	}
})
nodecore.register_cook_abm({nodenames = {modname.. ":pottery_adobe_pot_unfired"}, neighbors = {"group:flame"}})
nodecore.register_cook_abm({nodenames = {modname .. ":pottery_earthenware_pot"}})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "glaze earthenware pot",
	action = "pummel",
	wield = {name = "nc_tree:eggcorn"},
	after = rfcall,
	nodes = {
		{
			match = {name = modname.. ":pottery_earthenware_pot", empty = true},
			replace = modname .. ":pottery_earthenware_pot_glazed"
		}
	}
})
------------------------------------------------------------------------
if minetest.get_modpath("wc_noditions") then
	nodecore.register_craft({
		label = "glaze earthenware pot",
		action = "pummel",
		wield = {name = "wc_noditions:lump_sap"},
		after = rfcall,
		nodes = {
			{
				match = {name = modname.. ":pottery_earthenware_pot", empty = true},
				replace = modname .. ":pottery_earthenware_pot_glazed"
			}
		}
	})
end
-- ================================================================== --


