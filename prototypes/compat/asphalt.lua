local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

if mods["AsphaltRoadsPatched"] then
	-- Yes asphalt is typically composed 5-10% of bitumen, but this is more balanced, gameplay-wise
	local default_ingredients = mods["crushing-industry"] and {
		{type="item", name="stone", amount=8},
		{type="item", name="sand", amount=20},
		{type="item", name="tar", amount=3}
	} or {
		{type="item", name="stone-brick", amount=5},
		{type="item", name="stone", amount=8},
		{type="item", name="tar", amount=3}
	}

	local recipe_name = nil
	if settings.startup["scrap-chemistry-asphalt-compat"].value == "replace" then
		local recipe = data.raw.recipe["Arci-asphalt"]
		if recipe then
			recipe.ingredients = default_ingredients
			recipe.category = "crafting"
		end
	elseif settings.startup["scrap-chemistry-asphalt-compat"].value == "alternative" then
		data:extend({
			{
				type = "recipe",
				name = "Arci-asphalt-tar",
				icons = {
					{icon="__AsphaltRoadsPatched__/graphics/icons/hr/asphalt.png"},
					{icon="__scrap-chemistry__/graphics/icons/tar.png", shift={-8, -8}, scale=0.3, draw_background=true}
				},
				category = "crafting",
				subgroup = "Arci-asphalt-1",
				order = "A",
				enabled = false,
				allow_productivity = true,
				allow_decomposition = false,
				hide_from_signal_gui = false,
				energy_required = 10,
				ingredients = default_ingredients,
				results = {{type="item", name="Arci-asphalt", amount=10}}
			}
		})
		ftech.add_unlock("Arci-asphalt", "Arci-asphalt-tar")
	end
end
