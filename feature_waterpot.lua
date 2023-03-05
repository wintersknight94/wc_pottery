-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local get_node = minetest.get_node
------------------------------------------------------------------------
local cpotwet = modname .. ":pottery_waterpot_glazed"
local cpotdry = modname .. ":pottery_claypot_glazed"
-- ================================================================== --
local water	= "(nc_terrain_water.png^[verticalframe:32:8)^[opacity:160"
local ceramic	= modname.. "_ceramic.png"
------------------------------------------------------------------------
local glaze	= modname.. "_glaze.png"
local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
local glazform	= "nc_api_storebox_frame.png^[opacity:40"
local glazcera	= "(" ..ceramic.. ")^(" ..glaze.. ")"
local glazside	= "(" ..glazcera.. ")^(" ..glazpatt.. ")"
local glazetop	= "(" ..glazcera.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
local glazaqua	= "(" ..water.. ")^(" ..glazetop.. ")"
-- ================================================================== --
local cpotdirs = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1}
}
------------------------------------------------------------------------
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end
------------------------------------------------------------------------
local function soakup(pos)
	local any
	for _, p in pairs(findwater(pos)) do
		nodecore.node_sound(p, "dig")
		minetest.remove_node(p)
		any = true
	end
	return any
end
-- ================================================================== --
minetest.register_node(modname .. ":pottery_waterpot_glazed", {
	description = "Glazed Ceramic Waterpot",
	tiles = {
		glazside,
		glazcera,
		glazaqua
	},
	use_texture_alpha = "blend",
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		cracky = 3,
		moist = 1,
		coolant = 1,
		visinv = 1,
		storebox = 1,
		totable = 1,
		waterpot = 1,
		scaling_time = 200,
		stack_as_node = 1,
	},
	stack_max = 1,
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end
})
-- ================================================================== --
minetest.register_abm({
		label = "ceramic waterpot fill",
		interval = 1,
		chance = 10,
		nodenames = {cpotdry},
		neighbors = {"group:water"},
		action = function(pos)
			if soakup(pos) then
				nodecore.set_loud(pos, {name = cpotwet})
				return nodecore.fallcheck(pos)
			end
		end
	})

nodecore.register_aism({
		label = "ceramic waterpot stack fill",
		interval = 1,
		chance = 10,
		itemnames = {cpotdry},
		action = function(stack, data)
			if data.pos and soakup(data.pos) then
				local taken = stack:take_item(1)
				taken:set_name(cpotwet)
				if data.inv then taken = data.inv:add_item("main", taken) end
				if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
				return stack
			end
		end
	})
-- ================================================================== --
nodecore.register_craft({
	label = "dump waterpot",
	action = "pummel",
	toolgroups = {thumpy = 1},
	indexkeys = {cpotwet},
	nodes = {
		{
			match = cpotwet,
			replace = cpotdry
		}
	},
	after = function(pos)
		local found
		for _, d in pairs(cpotdirs) do
			local p = vector.add(pos, d)
			if nodecore.artificial_water(p, {
					matchpos = pos,
					match = cpotwet,
					minttl = 1,
					maxttl = 10
				}) then found = true end
		end
		if found then nodecore.node_sound(pos, "dig") end
	end
})
------------------------------------------------------------------------
-- ================================================================== --
if minetest.settings:get_bool(modname .. ".truewater", true) then
	nodecore.register_craft({
		label = "break ceramic waterpot apart",
		action = "pummel",
		indexkeys = {"group:waterpot"},
		nodes = {{match = {groups = {waterpot = true}}, replace = "nc_terrain:water_source"}},
		items = {{name = modname .. ":chip", count = 8, scatter = 5}},
		toolgroups = {cracky = 3, thumpy = 4},
		itemscatter = 5
	})
else
	nodecore.register_craft({
		label = "break ceramic waterpot apart",
		action = "pummel",
		indexkeys = {"group:waterpot"},
		nodes = {{match = {groups = {waterpot = true}}, replace = "nc_terrain:water_gray_source"}},
		items = {{name = modname .. ":chip", count = 8, scatter = 5}},
		toolgroups = {cracky = 3, thumpy = 4},
		itemscatter = 5
	})
end
-- ================================================================== --
