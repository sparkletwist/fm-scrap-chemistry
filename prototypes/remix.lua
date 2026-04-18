local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")
if (not remix) then return end

local frep = require("__fdsl__.lib.recipe")
frep.replace_ingredient("carbon", "sulfuric-acid", "methane", true)

local coal_item = mods["crushing-industry"] and settings.startup["crushing-industry-coal"].value and "crushed-coal" or "coal"

data:extend({
	{
		type = "fluid",
		name = "naphtha",
		subgroup = "fluid",
		default_temperature = 25,
		base_color = {0.66, 0.61, 0.32},
		flow_color = {0.92, 0.89, 0.1},
		icon = "__scrap-chemistry__/graphics/icons/fluid/naphtha.png",
		order = "a[fluid]-b[oil]-d[heavy-oil]-a[naphtha]"
	},	
	
	{
		type = "recipe",
		name = "naphtha-separation",
		category = "oil-processing",
		enabled = false,
		energy_required = 5,
		ingredients =
		{
			{type = "fluid", name = "naphtha", amount = 100}
		},
		results =
		{
			{type = "fluid", name = "petroleum-gas", amount = 20, fluidbox_index=1},
			{type = "fluid", name = "light-oil", amount = 70, fluidbox_index=2},
			{type = "fluid", name = "butane", amount = 20, fluidbox_index=3}
		},
		allow_productivity = true,
		icon = "__base__/graphics/icons/fluid/advanced-oil-processing.png",
		subgroup = "fluid-recipes",
		order = "a[oil-processing]-b[advanced-oil-processing]-n[naphtha]"
	},	
		
	{
		type = "recipe",
		name = "petroleum-gas",
		category = "chemistry",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-m[petroleum-gas-synthesis]",
		enabled = false,
		allow_productivity = true,
		show_amount_in_title = false,
		always_show_products = true,
		
		energy_required = 1,
		
		main_product = "petroleum-gas",
		
		ingredients = {
			{type="item", name=coal_item, amount=1},
			{type="fluid", name="methane", amount=40},
		},
				
		results = {
			{type="fluid", name="petroleum-gas", amount=20},
			{type="fluid", name="butane", amount=2},
		},
		
		crafting_machine_tint = {
			primary = {r = 0.768, g = 0.631, b = 0.768, a = 1.000},
			secondary = {r = 0.55, g = 0.42, b = 0.55, a = 1.000},
			tertiary = {r = 0.74, g = 0.72, b = 0.92, a = 1.000},
			quaternary = {r = 0.2, g = 0.2, b = 0.3, a = 1.000},
		}
	},	
})

if mods["space-age"] then
	data:extend({
		{
			type = "recipe",
			name = "methane-electrolysis",
			category = "electromagnetics",
			subgroup = "fulgora-processes",
			order = "b[holmium]-b[holmium-solution]-z[methane-electrolysis]",
			energy_required = 4,
			
			icons = {
				{ icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64 },
				{ icon = "__scrap-chemistry__/graphics/icons/fluid/methane.png", icon_size = 64, scale = 0.25, shift = {-8, -8} }
			},
						
			ingredients = {
				{type = "fluid", name = "methane", amount = 20 }
			},
			
			results = {
				{type = "fluid", name = "water", amount = 10 }
			},
			
			allow_productivity = true,
			enabled = false
		},
	})
end

ScrapIndustry.recipes["petroleum-gas"] = { ignore=true }

