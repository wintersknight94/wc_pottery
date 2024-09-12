 -- LUALOCALS < ---------------------------------------------------------
local include
    = include
-- LUALOCALS > ---------------------------------------------------------

include("substrate_clay")

include("feature_ceramic")

include("feature_clayware")

include("feature_earthenware")

include("feature_stoneware")

include("feature_porcelain")

include("feature_flowerpot")

include("feature_waterpot")

include("item_tools")

if minetest.get_modpath("wc_naturae") then
	include("feature_funguspot")
end

--include("decor_claysign")

--include("discovery")

include("conversion")