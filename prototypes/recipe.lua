local frep = require("__fdsl__.lib.recipe")

local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

local coal_item = mods["crushing-industry"] and settings.startup["crushing-industry-coal"].value and "crushed-coal" or "coal"

--- Fluidbox index priority for the oil refinery is as follows:
--- Heavy oil is prioritized at index 1
--- Light oil is prioritized at index 2
--- Butane is prioritized at index 3
--- Petroleum gas is prioritized at index 1 (but lower priority than Heavy oil)
--- Sour gas is a byproduct and goes wherever it fits

--- Naphtha is prioritized at index 2

data:extend({
	{
		type = "recipe",
		name = "methane",
		category = mods["space-age"] and "organic-or-chemistry" or "chemistry",
		subgroup = "fluid-recipes",
		order = "a[fluid]-b[oil]-m[methane]",
		enabled = false,
		allow_productivity = true,
		show_amount_in_title = false,
		energy_required = 1,
		ingredients = {
			{type="item", name=(remix and "solid-fuel") or coal_item, amount=1},
			{type="fluid", name="petroleum-gas", amount=20},
		},
				
		results = {{type="fluid", name="methane", amount=40}},
		crafting_machine_tint = {
			primary = {r = 0.6, g = 0.6, b = 0.8, a = 1.000},
			secondary = {r = 0.6, g = 0.592, b = 0.8, a = 1.000},
			tertiary = {r = 0.7, g = 0.6, b = 0.8, a = 1.000},
			quaternary = {r = 0.5, g = 0.3, b = 0.8, a = 1.000},
		}
	},
	{
		type = "recipe",
		name = "butane-pollution",
		icon = "__scrap-chemistry__/graphics/icons/fluid/butane-pollution.png",
		category = "oil-processing",
		subgroup = "fluid-recipes",
		order = "d[other-chemistry]-B[butane-pollution]",
		enabled = false,
		allow_productivity = true,
		hide_from_signal_gui = false,
		energy_required = 5,
		emissions_multiplier = 5,
		ingredients = {
			{type="fluid", name="butane", amount=120},
			{type="fluid", name="water", amount=100},
			{type="item", name="tar", amount=1}
		},
		results = {
			{type="fluid", name="light-oil", amount=60, fluidbox_index=2},
			{type="fluid", name="petroleum-gas", amount=30, fluidbox_index=1},
			{type="fluid", name=(remix and "sour-gas") or "butane", amount=20, fluidbox_index=3}
		}
	},
	{
		type = "recipe",
		name = "solid-fuel-from-butane",
		icon = "__scrap-chemistry__/graphics/icons/solid-fuel-from-butane.png",
		category = "chemistry",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-c[solid-fuel-from-butane]",
		enabled = false,
		allow_productivity = true,
		hide_from_signal_gui = false,
		energy_required = 1,
		ingredients = {{type="fluid", name="butane", amount=20}},
		results = {{type="item", name="solid-fuel", amount=1}},
		crafting_machine_tint = data.raw.recipe["solid-fuel-from-petroleum-gas"].crafting_machine_tint
	},
	{
		type = "recipe",
		name = "sour-gas-sweetening",
		icon = (remix and "__scrap-chemistry__/graphics/icons/remix/sour-gas-sweetening.png") or "__scrap-chemistry__/graphics/icons/fluid/sour-gas-sweetening.png",
		category = mods["space-age"] and "chemistry-or-cryogenics" or "chemistry",
		subgroup = "fluid-recipes",
		order = "d[other-chemistry]-D[sour-gas-sweetening]",
		enabled = false,
		allow_productivity = true,
		hide_from_signal_gui = false,
		energy_required = 1,
		
		main_product = (remix and "methane") or nil,
		
		ingredients = (remix and {
			{type="fluid", name="sour-gas", amount=50},
			{type="fluid", name="petroleum-gas", amount=5}				
		}) or {
			{type="item", name=mods["space-age"] and "calcite" or coal_item, amount=1},
			{type="fluid", name="sour-gas", amount=50}
		},
		
		results = (remix and {
			{type="fluid", name="methane", amount=50},
			{type="item", name="sulfur", probability=0.5, amount=1}
		}) or {
			{type="fluid", name="sulfuric-acid", amount=50}
		},
		crafting_machine_tint = (remix and {
			primary = {r = 0.6, g = 0.7, b = 0.4, a = 1.000},
			secondary = {r = 0.996, g = 0.742, b = 0.408, a = 1.000},
			tertiary = {r = 0.685, g = 0.64, b = 0.62, a = 0.94},
			quaternary = {r = 0.769, g = 0.800, b = 0.2, a = 1.000},			
		  
		}) or data.raw.recipe["sulfuric-acid"].crafting_machine_tint
	},
		
	{
		type = "recipe",
		name = "plastic-bar-from-butane",
		icons = {
			{icon="__scrap-chemistry__/graphics/icons/fluid/butane.png", shift={-12,-12}, scale=0.4},
			{icon="__base__/graphics/icons/plastic-bar.png", draw_background=true},
		},
		category = mods["space-age"] and "chemistry-or-cryogenics" or "chemistry",
		enabled = false,
		allow_productivity = true,
		auto_recycle = false,
		allow_decomposition = false,
		hide_from_signal_gui = false,
		energy_required = 1,
		ingredients = {
			{type="fluid", name="butane", amount=(remix and 40) or 20},
			table.pack(frep.get_ingredient("plastic-bar", coal_item))[2]
		},
		results = {
			{type="item", name="plastic-bar", amount=2}
		},
		crafting_machine_tint = data.raw.recipe["plastic-bar"].crafting_machine_tint
	},

	{
		type = "recipe",
		name = "tar-liquefaction",
		icon = "__scrap-chemistry__/graphics/icons/fluid/tar-liquefaction.png",
		category = "oil-processing",
		subgroup = "fluid-recipes",
		order = "a[oil-processing]-d[tar-liquefaction]",
		enabled = false,
		allow_productivity = true,
		hide_from_signal_gui = false,
		energy_required = 5,
		ingredients = {
			{type="item", name="tar", amount=10},
			{type="fluid", name="light-oil", amount=25, fluidbox_index=1},
			{type="fluid", name="steam", amount=150, fluidbox_index=2}
		},
		results = {
			{type="fluid", name="heavy-oil", amount=75, fluidbox_index=1},
			{type="fluid", name="petroleum-gas", amount=20, fluidbox_index=2},
			{type="fluid", name=(remix and "sour-gas") or "butane", amount=10, fluidbox_index=3}
		}
	}
})

if remix then

	ScrapIndustry.recipes["tar-liquefaction"] = { failrate=0.01, fake_ingredients={{type="fluid", name="steam", amount=150}} }
	
else

	data:extend({
		{
			type = "recipe",
			name = "tar",
			localised_name = {"recipe-name.synthetic-tar"},
			category = mods["space-age"] and "chemistry-or-cryogenics" or "chemistry",
			subgroup = "raw-material",
			order = "b[chemistry]-b[tar]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			allow_decomposition = false,
			hide_from_signal_gui = false,
			energy_required = 1,
			ingredients = {
				{type="fluid", name="heavy-oil", amount=50},
				{type="fluid", name="water", amount=20}
			},
			results = {{type="item", name="tar", amount=2}},
			crafting_machine_tint = {
				primary = {r = 1.000, g = 1.000, b = 1.000, a = 1.000}, -- #fefeffff
				secondary = {r = 0.771, g = 0.771, b = 0.771, a = 1.000}, -- #c4c4c4ff
				tertiary = {r = 0.768, g = 0.665, b = 0.762, a = 1.000}, -- #c3a9c2ff
				quaternary = {r = 0.000, g = 0.000, b = 0.000, a = 1.000}, -- #000000ff
			}
		},

		{
			type = "recipe",
			name = "sour-gas-pollution",
			icon = "__scrap-chemistry__/graphics/icons/fluid/sour-gas-pollution.png",
			category = mods["space-age"] and "organic-or-chemistry" or "chemistry",
			subgroup = "fluid-recipes",
			order = "d[other-chemistry]-D[sour-gas-sweetening]b",
			enabled = false,
			allow_productivity = true,
			hide_from_signal_gui = false,
			energy_required = 1,
			emissions_multiplier = 5,
			ingredients = {
				{type="item", name="solid-fuel", amount=1},
				{type="fluid", name="sour-gas", amount=30},
				{type="fluid", name="butane", amount=20}
			},
			results = {
				{type="fluid", name="light-oil", amount=10},
				{type="item", name="sulfur", amount=3}
			},
			crafting_machine_tint = {
				primary = {r = 0.800, g = 0.758, b = 0.000, a = 1.000},
				secondary = {r = 0.800, g = 0.652, b = 0.072, a = 1.000},
				tertiary = {r = 0.676, g = 0.669, b = 0.397, a = 1.000},
				quaternary = {r = 0.769, g = 0.800, b = 0.019, a = 1.000},
			} -- slightly darker sulfuric acid
		},
	})

end

-- Only add sulfur from sour gas if we're not replacing petroleum gas in sulfur
if (not remix and not settings.startup["scrap-chemistry-sulfur"].value) then
	data:extend({
		{
			type = "recipe",
			name = "sulfur-from-sour-gas",
			icons = {
				{icon="__scrap-chemistry__/graphics/icons/fluid/sour-gas.png", shift={-12,-12}, scale=0.4},
				{icon="__base__/graphics/icons/sulfur.png", draw_background=true}
			},
			category = "chemistry",
			order = "b[chemistry]-c[sulfur]-c[sour-gas]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			allow_decomposition = false,
			hide_from_signal_gui = false,
			energy_required = 1,
			ingredients = {
				{type="fluid", name="sour-gas", amount=30},
				{type="fluid", name="water", amount=30}
			},
			results = {{type="item", name="sulfur", amount=2}}
		}
	})
end

-------------------------------------------------------------------------- Butane/petroleum gas cracking

if (remix or settings.startup["scrap-chemistry-butane-realism"].value) then
	data:extend({
		{
			type = "recipe",
			name = "butane-cracking",
			icon = "__scrap-chemistry__/graphics/icons/fluid/butane-cracking.png",
			category = mods["space-age"] and "organic-or-chemistry" or "chemistry",
			subgroup = "fluid-recipes",
			order = "b[fluid-chemistry]-c[more]-a[butane-cracking]",
			enabled = false,
			allow_productivity = true,
			hide_from_signal_gui = false,
			energy_required = 2,
			-- Technically the ratios for this aren't quite right, but for balance reasons we shouldn't give more from less
			ingredients = {
				{type="fluid", name="butane", amount=20},
				{type="fluid", name="water", amount=30}
			},
			results = {{type="fluid", name="petroleum-gas", amount=10}},
			crafting_machine_tint = {
				primary = {r = 0.768, g = 0.631, b = 0.768, a = 1.000}, -- #c3a0c3ff
				secondary = {r = 0.659, g = 0.592, b = 0.678, a = 1.000}, -- #a896acff
				tertiary = {r = 0.774, g = 0.631, b = 0.766, a = 1.000}, -- #c5a0c3ff
				quaternary = {r = 0.564, g = 0.364, b = 0.564, a = 1.000}, -- #8f5c8fff
			}
		}
	})
	
	if (remix) then
		table.insert(data.raw.recipe["butane-cracking"], {type="fluid", name="methane", amount=5})
	end
	
else
	data:extend({
		{
			type = "recipe",
			name = "petroleum-gas-cracking",
			icon = "__scrap-chemistry__/graphics/icons/fluid/petroleum-gas-cracking.png",
			category = mods["space-age"] and "organic-or-chemistry" or "chemistry",
			subgroup = "fluid-recipes",
			order = "b[fluid-chemistry]-c[petroleum-gas-cracking]",
			enabled = false,
			allow_productivity = true,
			hide_from_signal_gui = false,
			energy_required = 2,
			-- Technically, 4*C3H8 (propane) + 2*H2O = 3*C4H10 (butane) + 1*O2
			-- but this is more balanced with butane pollution
			ingredients = {
				{type="fluid", name="petroleum-gas", amount=20},
				{type="fluid", name="water", amount=30}
			},
			results = {{type="fluid", name="butane", amount=10}},
			crafting_machine_tint = {
				primary = {r = 0.768, g = 0.631, b = 0.768, a = 1.000}, -- #c3a0c3ff
				secondary = {r = 0.659, g = 0.592, b = 0.678, a = 1.000}, -- #a896acff
				tertiary = {r = 0.774, g = 0.631, b = 0.766, a = 1.000}, -- #c5a0c3ff
				quaternary = {r = 0.564, g = 0.364, b = 0.564, a = 1.000}, -- #8f5c8fff
			}
		}
	})
end

-------------------------------------------------------------------------- Space Age

if mods["space-age"] then
	if (not remix) then
		data:extend({
			{
				type = "recipe",
				name = "methane-from-carbon",
				icons = {
					{icon="__space-age__/graphics/icons/carbon.png", shift={-8,-8}, scale=0.3, draw_background=true},
					{icon="__base__/graphics/icons/fluid/water.png", shift={8,-8}, scale=0.3, draw_background=true},
					{icon="__scrap-chemistry__/graphics/icons/fluid/methane.png", shift={0,4}, scale=0.4, draw_background=true}
				},
				category = "organic-or-chemistry",
				subgroup = "fluid-recipes",
				order = "d[other-chemistry]-B[methane-from-carbon]",
				enabled = false,
				allow_productivity = true,
				show_amount_in_title = false,
				always_show_products = true,
				auto_recycle = false,
				energy_required = 1,
				ingredients = {
					{type="item", name="carbon", amount=2},
					{type="fluid", name="water", amount=10}
				},
				results = {
					{type="fluid", name="methane", amount=20}
				},
				crafting_machine_tint = {
					primary = {r = 1.0, g = 0.7, b = 0.0, a = 1.000},
					secondary = {r = 0.996, g = 0.742, b = 0.408, a = 1.000},
					tertiary = {r = 0.768, g = 0.665, b = 0.762, a = 1.000},
					quaternary = {r = 0.656, g = 0.562, b = 0.264, a = 1.000},
				}
			},
	
			{
				type = "recipe",
				name = "hydrazine",
				category = "chemistry-or-cryogenics",
				subgroup = "aquilo-processes",
				order = "a[ammonia]-c[hydrazine]",
				enabled = false,
				allow_productivity = true,
				auto_recycle = false,
				energy_required = 10,
				ingredients = {
					{type="fluid", name="ammonia", amount=100},
					{type="fluid", name="water", amount=10},
					{type="fluid", name="butane", amount=50}
				},
				results = {
					{type="fluid", name="hydrazine", amount=100},
					{type="item", name="carbon", amount=1}
				},
				main_product = "hydrazine"
			}
		})

		if (settings.startup["scrap-chemistry-sulfur"].value) then
			data:extend({
				{
					type = "recipe",
					name = "electrolyte-souring",
					icons = {
						{icon="__space-age__/graphics/icons/fluid/electrolyte.png", shift={0,-4}, scale=0.4},
						{icon="__scrap-chemistry__/graphics/icons/fluid/electrolyte-souring-overlay.png", shift={0,2}, scale=0.45, draw_background=true}
					},
					category = "electromagnetics",
					subgroup = "fulgora-processes",
					order = "b[holmium]-e[electrolyte]-b[souring]",
					enabled = false,
					allow_productivity = true,
					auto_recycle = false,
					allow_decomposition = false,
					hide_from_signal_gui = false,
					energy_required = 5,
					ingredients = {
						{type="fluid", name="electrolyte", amount=10},
						{type="fluid", name="steam", amount=50}
					},
					results = {{type="fluid", name="sour-gas", amount=50}}
				}
			})
		end
	end
end
