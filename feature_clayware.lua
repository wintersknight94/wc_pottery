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
local ceramic	= modname.. "_ceramic.png"
local cerasoft	= ceramic.. "^(nc_concrete_pliant.png^[opacity:100)"
local form		= "nc_tree_tree_side.png^[mask:nc_api_storebox_frame.png"
local clayform	= "(" ..cerasoft.. ")^(" ..form.. ")"
local ceraform	= ceramic.. "^[mask:nc_api_storebox_frame.png"
------------------------------------------------------------------------
local glaze	= modname.. "_glaze.png"
local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
local glazform	= "nc_api_storebox_frame.png^[opacity:40"
local glazcera	= "(" ..ceramic.. ")^(" ..glaze.. ")"
local glazside	= "(" ..glazcera.. ")^(" ..glazpatt.. ")"
local glazetop	= "(" ..glazcera.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
-- ================================================================== --
minetest.register_node(modname .. ":pottery_claypot_unfired", {
	description = "Unfired Ceramic Pot",
	tiles = {
		clayform,
		clayform,
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
minetest.register_node(modname .. ":pottery_clayware_pot", {
	description = "Clayware Pot",
	tiles = {
		ceramic,
		ceramic,
		ceraform
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 2,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 150,
		ceramic = 2
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":pottery_clayware_pot_glazed", {
	description = "Glazed Clayware Pot",
	tiles = {
		glazside,
		glazcera,
		glazetop
	},
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 3,
		visinv = 1,
		storebox = 1,
		totable = 1,
		scaling_time = 200,
		ceramic = 3
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
-- ================================================================== --
nodecore.register_craft({
	label = "form pliant ceramic",
	action = "pummel",
	wield = {name = "nc_woodwork:form"},
	after = rfcall,
	nodes = {
		{match = "nc_concrete:" ..modname.. "_ceramic_blank_ply", replace = modname .. ":pottery_claypot_unfired"}
	}
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "fire claypot",
	action = "cook",
	touchgroups = {flame = 2},
	neargroups = {coolant = 0},
	duration = 30,
	cookfx = true,
	indexkeys = {modname.. ":pottery_claypot_unfired"},
	nodes = {
		{
			match = {name = modname.. ":pottery_claypot_unfired", empty = true},
			replace = modname .. ":pottery_clayware_pot"
		}
	}
})
nodecore.register_cook_abm({nodenames = {modname.. ":pottery_claypot_unfired"}, neighbors = {"group:flame"}})
nodecore.register_cook_abm({nodenames = {modname .. ":pottery_clayware_pot"}})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "glaze clayware pot",
	action = "pummel",
	wield = {name = "nc_tree:eggcorn"},
	after = rfcall,
	nodes = {
		{
			match = {name = modname.. ":pottery_clayware_pot", empty = true},
			replace = modname .. ":pottery_clayware_pot_glazed"
		}
	}
})
------------------------------------------------------------------------
if minetest.get_modpath("wc_noditions") then
	nodecore.register_craft({
		label = "glaze clayware pot with resin",
		action = "pummel",
		wield = {name = "wc_noditions:lump_sap"},
		after = rfcall,
		nodes = {
			{
				match = {name = modname.. ":pottery_clayware_pot", empty = true},
				replace = modname .. ":pottery_clayware_pot_glazed"
			}
		}
	})
end
-- ================================================================== --
nodecore.register_abm({
		label = "wash unfired pottery",
		nodenames = {"group:unfired_clay"},
		neighbors = {"group:water"},
		interval = 10,
		chance = 4,
		action = function(pos)
		 	nodecore.item_eject(pos, modname.. ":lump_clay", 1, 8)
			nodecore.sound_play("nc_terrain_watery", {gain = 0.25, pos = pos})
			minetest.set_node(pos, {name = "nc_woodwork:form"})
		end
	})
nodecore.register_aism({
	label = "stack wash unfired pottery",
	interval = 8,
	chance = 4,
	itemnames = {"group:unfired_clay"},
	action = function(stack, data)
		if data.player and (data.list ~= "main"
			or data.slot ~= data.player:get_wield_index()) then return end
		if #findwater(data.pos) >= 1 then
			nodecore.sound_play("nc_terrain_watery", {gain = 0.25, pos = pos})
			local taken = stack:take_item(1)
			taken:set_name("nc_woodwork:form")
				nodecore.item_eject(data.pos, modname.. ":lump_clay", 1, 8,{x = 1, y = 1, z = 1})
			if data.inv then taken = data.inv:add_item("main", taken) end
				if not taken:is_empty() then nodecore.item_eject(data.pos, taken) 
				nodecore.item_eject(data.pos, modname.. ":lump_clay", 1, 8,{x = 1, y = 1, z = 1})
				end
			return stack
		end
	end
})
-- ================================================================== --
