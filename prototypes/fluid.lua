local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

-- only add a fuel value if we care about fuel values
-- (only in remix mode for now in case this breaks something)
local gas_fuel_value = true
if remix then
	gas_fuel_value = false
	if (data.raw.fluid["light-oil"].fuel_value or data.raw.fluid["petroleum-gas"].fuel_value) then
		gas_fuel_value = true
	end
end

data:extend({
	{
		type = "fluid",
		name = "butane",
		icon = "__scrap-chemistry__/graphics/icons/fluid/butane.png",
		subgroup = "fluid",
		order = "a[fluid]-b[oil]-b[petroleum-gas]-b[butane]",
		default_temperature = 25,
		--gas_temperature = 25,
		fuel_value = (gas_fuel_value and "900kJ") or nil, -- Balanced relative to fuel values provided by Gas Boiler
		base_color = {0.4, 0.2, 0.4},
		flow_color = {0.9, 0.9, 0.9}
	},
	{
		type = "fluid",
		name = "sour-gas",
		icon = "__scrap-chemistry__/graphics/icons/fluid/sour-gas.png",
		subgroup = "fluid",
		order = "a[fluid]-b[oil]-f[sulfuric-acid]-b[sour-gas]",
		default_temperature = 25,
		--gas_temperature = 25,
		base_color = {0.85, 0.75, 0.2},
		flow_color = {0.9, 1, 0.25},
	},
	{
		type = "fluid",
		name = "methane",
		icon = "__scrap-chemistry__/graphics/icons/fluid/methane.png",
		subgroup = "fluid",
		order = "a[fluid]-b[oil]-m[methane]",
		default_temperature = 15,
		--gas_temperature = 15,
		max_temperature = 535,
		heat_capacity = "0.22kJ",
		fuel_value = (gas_fuel_value and "300kJ") or nil, -- Balanced relative to fuel values provided by Gas Boiler
		auto_barrel = false,
		base_color = {0.5, 0.5, 1},
		flow_color = {1, 1, 1}
	}
})

if mods["space-age"] then
	if (not remix) then
		data:extend({
			{
				type = "fluid",
				name = "hydrazine",
				icon = "__scrap-chemistry__/graphics/icons/fluid/hydrazine.png",
				subgroup = "fluid",
				order = "b[new-fluid]-e[aquilo]-c[hydrazine]",
				default_temperature = 25,
				heat_capacity = "0.44kJ",
				fuel_value = (gas_fuel_value and "2.4MJ") or nil,
				base_color = {0.25, 0.25, 1},
				flow_color = {0.75, 0.75, 1}
			}
		})
	end
end
