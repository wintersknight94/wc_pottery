-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs
    = minetest, nodecore, pairs
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local localpref = "nc_concrete:" .. modname:gsub("^nc_", "") .. "_"
-- ================================================================== --
local clay = "nc_terrain_dirt.png^[colorize:tan:100"
local chip = "nc_stonework_stone.png^[colorize:tan:100"
local form = "nc_tree_tree_side.png^[mask:nc_api_storebox_frame.png"
------------------------------------------------------------------------
local ceramic = modname.. "_ceramic.png"
local ceramix = clay.. "^(nc_fire_ash.png^[mask:nc_concrete_mask.png)"
local clayform = "(" ..clay.. ")^(" ..form.. ")"
local ceraform = ceramic.. "^[mask:nc_api_storebox_frame.png"
-- ================================================================== --
minetest.register_craftitem(modname .. ":chip", {
	description = "Ceramic Chip",
	inventory_image = chip,
	sounds = nodecore.sounds("nc_optics_glassy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":ceramic", {
	description = "Ceramic",
	tiles = {ceramic},
	groups = {
		cracky = 1,
		ceramic = 1
	},
	drop_in_place = modname.. ":clay",
	crush_damage = 2,
	sounds = nodecore.sounds("nc_optics_glassy")
})
-- ================================================================== --
nodecore.register_concrete_etchable({
	basename = modname .. ":ceramic",
	pliant_opacity = 40,
	pattern_opacity = 80,
	pliant = {
		sounds = nodecore.sounds("nc_terrain_crunchy"),
		drop_in_place = {"nc_concrete:ceramix_wet_source"},
		silktouch = false
	}
})
------------------------------------------------------------------------
nodecore.register_concrete({
	name = "ceramix",
	description = "Ceramix",
	tile_powder = ceramix,
	tile_wet = clay.. "^(nc_fire_ash.png^("
	.. "nc_terrain_gravel.png^[opacity:128)^[mask:nc_concrete_mask.png)",
	sound = "nc_terrain_chompy",
	groups_powder = {crumbly = 1},
	swim_color = {r = 110, g = 110, b = 70},
	craft_from_keys = {"group:clay"},
	craft_from = {groups = {clay = true}},
	to_crude = modname.. ":clay",
	to_washed = modname.. ":clay",
	to_molded = localpref .. "ceramic_blank_ply"
})
------------------------------------------------------------------------
nodecore.register_stone_bricks("ceramic", "Ceramic",
	ceramic,
	180, 80,
	modname .. ":ceramic",
	{cracky = 2},
	{
		cracky = 3,
		nc_door_scuff_opacity = 45,
		door_operate_sound_volume = 40
	}
)
-- ================================================================== --
nodecore.register_craft({
	label = "break ceramic to chips",
	action = "pummel",
	indexkeys = {"group:ceramic"},
	nodes = {{match = {groups = {ceramic = true}}, replace = "air"}},
	items = {{name = modname .. ":chip", count = 8, scatter = 5}},
	toolgroups = {cracky = 3, thumpy = 4},
	itemscatter = 5
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "pack ceramic chips",
	action = "pummel",
	toolgroups = {thumpy = 2},
	indexkeys = {modname .. ":chip"},
	nodes = {
		{
			match = {name = modname .. ":chip", count = 8},
			replace = "nc_concrete:ceramix"
		}
	}
})
-- ================================================================== --
minetest.override_item("nc_stonework:bricks_ceramic",
	{sounds = nodecore.sounds("nc_optics_glassy")}
)
minetest.override_item("nc_stonework:bricks_ceramic_bonded",
	{sounds = nodecore.sounds("nc_optics_glassy")}
)
minetest.override_item("nc_doors:panel_bricks_ceramic_bonded",
	{sounds = nodecore.sounds("nc_optics_glassy")}
)
minetest.override_item("nc_doors:door_bricks_ceramic_bonded",
	{sounds = nodecore.sounds("nc_optics_glassy")}
)
-- ================================================================== --

