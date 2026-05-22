local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")
if (not remix) then return end

local frep = require("__fdsl__.lib.recipe")
frep.replace_ingredient("carbon", "sulfuric-acid", "methane", true)

--local coal_item = mods["crushing-industry"] and settings.startup["crushing-industry-coal"].value and "crushed-coal" or "coal"

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
		main_product = "",
		allow_productivity = true,
		icon = "__scrap-chemistry__/graphics/icons/remix/naphtha-separation.png",
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
		
		energy_required = 2,
		
		main_product = "petroleum-gas",
		
		ingredients = {
			{type="item", name="solid-fuel", amount=1},
			{type="fluid", name="methane", amount=80},
		},
				
		results = {
			{type="fluid", name="petroleum-gas", amount=40},
			{type="fluid", name="butane", amount=10},
		},
		
		crafting_machine_tint = {
			primary = {r = 0.768, g = 0.631, b = 0.768, a = 1.000},
			secondary = {r = 0.55, g = 0.42, b = 0.55, a = 1.000},
			tertiary = {r = 0.74, g = 0.72, b = 0.92, a = 1.000},
			quaternary = {r = 0.2, g = 0.2, b = 0.3, a = 1.000},
		}
	},
	
	{
		type = "item",
		name = "impure-fuel",
		icon = "__scrap-chemistry__/graphics/icons/remix/impure-fuel.png",
		fuel_category = "chemical",
		fuel_value = data.raw.item["solid-fuel"].fuel_value,
		fuel_acceleration_multiplier = 0.85,
		fuel_top_speed_multiplier = 0.95,
		fuel_emissions_multiplier = 5.0,
		subgroup = "raw-material",
		order = "b[chemistry]-a[solid-fuel]-x[impure-fuel]",
		inventory_move_sound = data.raw.item["solid-fuel"].inventory_move_sound,
		pick_sound = data.raw.item["solid-fuel"].pick_sound,
		drop_sound = data.raw.item["solid-fuel"].drop_sound,
		stack_size = data.raw.item["solid-fuel"].stack_size,
		weight = data.raw.item["solid-fuel"].weight,
		random_tint_color = item_tints.yellowing_coal
	},
	
	{
		type = "recipe",
		name = "impure-fuel",
		category = "chemistry",
		energy_required = 2,
		ingredients = {
			{type = "fluid", name = "sour-gas", amount = 40}
		},
		results = {
			{type = "item", name = "impure-fuel", amount = 1}
		},
		
		allow_productivity = true,
		subgroup = "fluid-recipes",
		enabled = false,
		order = "b[fluid-chemistry]-x[impure-fuel]",
		crafting_machine_tint =
		{
			primary = {r = 0.710, g = 0.72, b = 0.52, a = 1.000},
			secondary = {r = 0.745, g = 0.672, b = 0.55, a = 1.000},
			tertiary = {r = 0.876, g = 0.869, b = 0.597, a = 1.000}, 
			quaternary = {r = 0.969, g = 1.000, b = 0.2, a = 1.000},
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
			
			surface_conditions = {
				{
					property = "pressure",
					min = 600
				}
			},
			
			
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
		
		{
			type = "fluid",
			name = "fulgora-oil",
			subgroup = "fluid",
			default_temperature = 25,
			base_color = {0.4, 0.12, 0.1},
			flow_color = {0.75, 0.5, 0.22},
			icon = "__scrap-chemistry__/graphics/icons/fluid/fulgora-oil.png",
			order = "a[fluid]-b[oil]-d[heavy-oil]-b[fulgora]"
		},

		{
			type = "recipe",
			name = "fulgora-oil-separation",
			category = "chemistry",
			enabled = false,
			energy_required = 1,
			ingredients =
			{
				{type = "fluid", name = "fulgora-oil", amount = 400},
				{type = "fluid", name = "water", amount = 10}
			},
			results =
			{
				{type = "fluid", name = "heavy-oil", amount = 350},
				{type = "fluid", name = "naphtha", amount = 100},
				-- tar added later
			},
			allow_productivity = true,
			icon = "__scrap-chemistry__/graphics/icons/remix/fulgora-oil-separation.png",
			subgroup = "fluid-recipes",
			order = "b[fluid-chemistry]-c[more]-f[fulgora-oil]",
			
			crafting_machine_tint = {
				primary = {r = 0.854, g = 0.659, b = 0.576, a = 1.000},
				secondary = {r = 1.000, g = 0.722, b = 0.376, a = 1.000},
				tertiary = {r = 0.92, g = 0.71, b = 0.58, a = 1.000},
				quaternary = {r = 0.66, g = 0.33, b = 0.18, a = 1.000},
			}			
			
		},
	
	})
	
	data.raw.tile["oil-ocean-shallow"].fluid = "fulgora-oil"
	data.raw.tile["oil-ocean-deep"].fluid = "fulgora-oil"
	
end

ScrapIndustry.recipes["petroleum-gas"] = { ignore=true }

