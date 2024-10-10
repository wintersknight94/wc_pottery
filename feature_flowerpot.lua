-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
-- ================================================================== --
local potsoil	= "nc_tree_humus.png"
local ceramic	= modname.. "_ceramic.png"
local earthen	= "nc_concrete_adobe.png"
local stonwar	= ceramic.. "^[colorize:black:128"
local porcela	= "nc_concrete_cloudstone.png"
-- ================================================================== --
local function register_flowerpot(material, desc, texture)
------------------------------------------------------------------------
	local ceraform	= texture.. "^[mask:nc_api_storebox_frame.png"
	local cerasoil	= "(" ..potsoil.. ")^(" ..ceraform.. ")"
------------------------------------------------------------------------
	local glaze		= modname.. "_glaze.png"
	local glazpatt	= modname.. "_glaze_pattern.png^[opacity:40"
	local glazform	= "nc_api_storebox_frame.png^[opacity:40"
	local glazcera	= "(" ..texture.. ")^(" ..glaze.. ")"
	local glazside	= "(" ..glazcera.. ")^(" ..glazpatt.. ")"
	local glazetop	= "(" ..glazcera.. ")^(" ..glazform.. ")^[mask:nc_api_storebox_frame.png"
	local glazsoil	= "(" ..potsoil.. ")^(" ..glazetop.. ")"
------------------------------------------------------------------------
------------------------------------------------------------------------
	minetest.register_node(modname .. ":pottery_" ..material.. "_flowerpot", {
		description = desc.. " Flowerpot",
		tiles = {
			cerasoil,
			texture,
			texture
		},
		selection_box = nodecore.fixedbox(),
		collision_box = nodecore.fixedbox(),
		groups = {
			soil = 4,
			cracky = 2,
			totable = 1,
			flowerpot = 1,
			scaling_time = 150,
			falling_node = 1,
		},
		paramtype = "light",
		sounds = nodecore.sounds("nc_optics_glassy")
	})
------------------------------------------------------------------------
	minetest.register_node(modname .. ":pottery_" ..material.. "_flowerpot_glazed", {
		description = "Glazed " ..desc.. " Flowerpot",
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
			falling_node = 1,
		},
		paramtype = "light",
		sounds = nodecore.sounds("nc_optics_glassy")
	})
------------------------------------------------------------------------
------------------------------------------------------------------------
	nodecore.register_craft({
		label = "fill " ..material.. " pot with compost",
		action = "stackapply",
		indexkeys = {modname.. ":pottery_" ..material.. "_pot"},
		wield = {groups = {humus = true}},
		consumewield = 1,
		nodes = {
			{
				match = {name = modname.. ":pottery_" ..material.. "_pot", empty = true},
				replace = modname .. ":pottery_" ..material.. "_flowerpot"
			},
		}
	})
------------------------------------------------------------------------
	nodecore.register_craft({
		label = "fill glazed " ..material.. " pot with compost",
		action = "stackapply",
		indexkeys = {modname.. ":pottery_" ..material.. "_pot_glazed"},
		wield = {groups = {humus = true}},
		consumewield = 1,
		nodes = {
			{
				match = {name = modname.. ":pottery_" ..material.. "_pot_glazed", empty = true},
				replace = modname .. ":pottery_" ..material.. "_flowerpot_glazed"
			},
		}
	})
------------------------------------------------------------------------
	nodecore.register_craft({
		label = "empty " ..material.. " flowerpot",
		action = "pummel",
		indexkeys = {modname.. ":pottery_" ..material.. "_flowerpot"},
		nodes = {
			{match = {name = modname.. ":pottery_" ..material.. "_flowerpot"}, 
			replace = modname.. ":pottery_" ..material.. "_pot"}
		},
		items = {
			{name = "nc_terrain:dirt_loose", count = 1, scatter = 1},
		},
		toolgroups = {crumbly = 2},
		itemscatter = 1
	})
------------------------------------------------------------------------
	nodecore.register_craft({
		label = "empty glazed " ..material.. " flowerpot",
		action = "pummel",
		indexkeys = {modname.. ":pottery_" ..material.. "_flowerpot_glazed"},
		nodes = {
			{match = {name = modname.. ":pottery_" ..material.. "_flowerpot_glazed"}, 
			replace = modname.. ":pottery_" ..material.. "_pot_glazed"}
		},
		items = {
			{name = "nc_terrain:dirt_loose", count = 1, scatter = 1},
		},
		toolgroups = {crumbly = 2},
		itemscatter = 1
	})
------------------------------------------------------------------------
end
-- ================================================================== --
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
-- <>=====<> Material <>==========<> Description <>=====<> Texture <> --
register_flowerpot("clayware",		"Clayware",			ceramic)
register_flowerpot("earthenware",	"Earthenware",		earthen)		
register_flowerpot("stoneware",		"Stoneware",		stonwar)
register_flowerpot("porcelain",		"Porcelain",		porcela)
