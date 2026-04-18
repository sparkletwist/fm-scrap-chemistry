local frep = require("__fdsl__.lib.recipe")

local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

-------------------------------------------------------------------------- Oil processing

-- Basic oil processing
local _,basic_petroleum_result = frep.get_result("basic-oil-processing", "petroleum-gas")
if basic_petroleum_result then
	data.raw.recipe["basic-oil-processing"].icon = "__scrap-chemistry__/graphics/icons/fluid/basic-oil-processing.png"
	
	local amount = basic_petroleum_result.amount
	basic_petroleum_result.fluidbox_index = 1
	if remix then
		basic_petroleum_result.name = "heavy-oil"
		basic_petroleum_result.amount = amount - 35
		if (basic_petroleum_result.amount < 10) then basic_petroleum_result.amount = 10 end
	else
		basic_petroleum_result.amount = amount - 25
	end
	frep.add_result("basic-oil-processing", {type="fluid", name="butane", amount=amount, fluidbox_index=3})
	frep.add_result("basic-oil-processing", {type="fluid", name="sour-gas", amount=amount-10, fluidbox_index=2})
end

-- Easier to just replace it, we can fix compat later if this is a problem
if remix then
	local _,heavy_oil_result = frep.get_result("advanced-oil-processing", "heavy-oil")
	local heavy_oil_amount = (heavy_oil_result and heavy_oil_result.amount) or 25
	
	local _,gas_result = frep.get_result("advanced-oil-processing", "petroleum-gas")
	local gas_amount = (gas_result and gas_result.amount) or 55
	gas_amount = gas_amount - 10
	if (gas_amount < 10) then gas_amount = 10 end
	
	data.raw.recipe["advanced-oil-processing"].results = {
		{type = "fluid", name = "heavy-oil", amount = heavy_oil_amount, fluidbox_index = 1},
		{type = "fluid", name = "sour-gas", amount = gas_amount, fluidbox_index = 2},
		{type = "fluid", name = "naphtha", amount = 65, fluidbox_index = 3}
	}
end

local function fudge_results(recipe_name, extra_amount)
	extra_amount = extra_amount or 0
	local recipe = data.raw.recipe[recipe_name]
	if recipe and recipe.results then
		for _,result in pairs(recipe.results) do
			if result.amount then
				local scale = 1 - 0.4 * math.random()
				result.amount_min = scale * result.amount + extra_amount
				result.amount_max = result.amount + extra_amount
				result.amount = nil
			end
		end
	end
end

fudge_results("basic-oil-processing")
fudge_results("advanced-oil-processing", 10)
fudge_results("tar-liquefaction")
fudge_results("petroleum-gas-cracking")
fudge_results("sour-gas-sweetening")
fudge_results("sour-gas-pollution")
fudge_results("butane-pollution")

if remix then
	fudge_results("naphtha-separation")
	frep.add_result("basic-oil-processing", {type="item", name="tar", amount=1, extra_count_fraction=0.41})
else
	frep.add_result("basic-oil-processing", {type="item", name="tar", amount=2, probability=0.47})
	frep.replace_result("advanced-oil-processing", "petroleum-gas", "butane")
end

frep.add_result("advanced-oil-processing", {type="item", name="tar", amount=1, probability=0.29})

-------------------------------------------------------------------------- Methane

frep.replace_ingredient("explosives", "water", "methane")

if settings.startup["scrap-chemistry-rocket-fuel"].value then
	local rocket_fuel_recipe = data.raw.recipe["rocket-fuel"]
	if rocket_fuel_recipe then
		rocket_fuel_recipe.auto_recycle = false
		frep.add_category("rocket-fuel", "chemistry")
		frep.add_ingredient("rocket-fuel", {type="fluid", name="methane", amount=20})
		rocket_fuel_recipe.crafting_machine_tint = rocket_fuel_recipe.crafting_machine_tint or {
			primary = {r = 1.0, g = 0.7, b = 0.0, a = 1.000},
			secondary = {r = 0.996, g = 0.742, b = 0.408, a = 1.000},
			tertiary = {r = 0.768, g = 0.665, b = 0.762, a = 1.000},
			quaternary = {r = 0.656, g = 0.562, b = 0.264, a = 1.000},
		}
	end

	if mods["space-age"] then
		frep.replace_ingredient("rocket-fuel-from-jelly", "water", "methane")
	end
end

if not remix then
	if mods["space-age"] and settings.startup["scrap-chemistry-thruster"].value then
		frep.replace_ingredient("thruster-fuel", "carbon", {type="fluid", name="methane", amount=20})
		local advanced_thruster_fuel = data.raw.recipe["advanced-thruster-fuel"]
		if advanced_thruster_fuel then
			frep.replace_ingredient("advanced-thruster-fuel", "carbon", {type="fluid", name="methane", amount=20})
			advanced_thruster_fuel.icons = {
				{icon="__scrap-chemistry__/graphics/icons/fluid/methane.png", shift={-8,-8}, scale=0.3, draw_background=true},
				{icon="__space-age__/graphics/icons/calcite.png", shift={8,-8}, scale=0.3, draw_background=true},
				{icon="__space-age__/graphics/icons/fluid/thruster-fuel.png", shift={0,4}, scale=0.4, draw_background=true}
			}
		end
	end
end

-------------------------------------------------------------------------- Sulfur

if (remix or settings.startup["scrap-chemistry-sulfur"].value) then
	frep.replace_ingredient("sulfur", "petroleum-gas", "sour-gas")
	frep.add_result("heavy-oil-cracking", {type="fluid", name="sour-gas", amount=10})
	frep.add_result("light-oil-cracking", {type="fluid", name="sour-gas", amount=5})
	
	if (not remix) then
		if settings.startup["scrap-chemistry-butane-realism"].value then
			frep.add_result("butane-cracking", {type="fluid", name="sour-gas", amount=5})
		else
			frep.add_result("petroleum-gas-cracking", {type="fluid", name="sour-gas", amount=5})
		end

		if mods["space-age"] then
			local sulfur_geyser = data.raw.resource["sulfuric-acid-geyser"]
			if sulfur_geyser then
				sulfur_geyser.localised_name = {"entity-name.sour-gas-geyser"}
				if sulfur_geyser.minable then
					for _,result in pairs(sulfur_geyser.minable.results or {}) do
						if result.name == "sulfuric-acid" then
							result.name = "sour-gas"
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------- Tar

frep.add_ingredient("flamethrower-ammo", {type="item", name="tar", amount=2})
local coal_liquefaction = data.raw.recipe["coal-liquefaction"]
if coal_liquefaction then
	coal_liquefaction.icon = "__scrap-chemistry__/graphics/icons/fluid/coal-liquefaction.png"
	frep.replace_ingredient("coal-liquefaction", "heavy-oil", "light-oil")
	frep.replace_result("coal-liquefaction", "petroleum-gas", "butane")
	frep.replace_result("coal-liquefaction", "light-oil", "petroleum-gas")
	frep.replace_result("coal-liquefaction", "heavy-oil", "light-oil")
end

if mods["space-age"] then
	local simple_coal_liquefaction = data.raw.recipe["simple-coal-liquefaction"]
	if simple_coal_liquefaction then
		if remix then
			-- Liquefaction should give us a liquid, but keep the process messy
			simple_coal_liquefaction.icon = "__scrap-chemistry__/graphics/icons/remix/simple-coal-liquefaction.png"
			frep.replace_result(simple_coal_liquefaction, "heavy-oil", "crude-oil")
			frep.add_result(simple_coal_liquefaction, {type="item", name="tar", amount=1})			
		elseif settings.startup["scrap-chemistry-butane-realism"].value then
			-- Butane is the WORST, so make it the main result =D
			simple_coal_liquefaction.icons = {
				{icon="__space-age__/graphics/icons/calcite-2.png", shift={-6,-6}, scale=0.3, draw_background=true},
				{icon="__scrap-chemistry__/graphics/icons/fluid/simple-coal-liquefaction-overlay-butane.png", draw_background=true},
			}
			frep.replace_result("simple-coal-liquefaction", "heavy-oil", {type="fluid", name="butane", amount=50, fluidbox_index=3})
			frep.add_result("simple-coal-liquefaction", {type="fluid", name="petroleum-gas", amount=10, fluidbox_index=1})
			frep.add_result("simple-coal-liquefaction", {type="item", name="tar", amount=1})
		else
			simple_coal_liquefaction.icons = {
				{icon="__space-age__/graphics/icons/calcite-2.png", shift={-6,-6}, scale=0.3, draw_background=true},
				{icon="__scrap-chemistry__/graphics/icons/fluid/simple-coal-liquefaction-overlay.png", draw_background=true},
			}
			frep.replace_result("simple-coal-liquefaction", "heavy-oil", {type="fluid", name="petroleum-gas", amount=50, fluidbox_index=1})
			frep.add_result("simple-coal-liquefaction", {type="fluid", name="butane", amount=10, fluidbox_index=3})
			frep.add_result("simple-coal-liquefaction", {type="item", name="tar", amount=1})
		end
	end
end

-------------------------------------------------------------------------- Hydrazine

if (mods["space-age"] and not remix) then
	if settings.startup["scrap-chemistry-rocket-fuel"].value then
		local ammonia_rocket_fuel = data.raw.recipe["ammonia-rocket-fuel"]
		if ammonia_rocket_fuel then
			ammonia_rocket_fuel.localised_name = {"recipe-name.hydrazine-rocket-fuel"}
			ammonia_rocket_fuel.icon = "__scrap-chemistry__/graphics/icons/hydrazine-rocket-fuel.png"
			ammonia_rocket_fuel.order = "a[ammonia]-c[hydrazine]-a[rocket-fuel]"
			frep.remove_ingredient("ammonia-rocket-fuel", "water")
			frep.replace_ingredient("ammonia-rocket-fuel", "ammonia", "hydrazine")
		end
	end
	frep.replace_ingredient("fluoroketone", "ammonia", "hydrazine")
	frep.replace_ingredient("fusion-power-cell", "ammonia", "hydrazine")
end
