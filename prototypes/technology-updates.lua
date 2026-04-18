local ftech = require("__fdsl__.lib.technology")

local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if (remix or settings.startup["scrap-chemistry-butane-realism"].value) then
	ftech.add_unlock("oil-processing", "butane-cracking", 4)
else
	ftech.add_unlock("oil-processing", "petroleum-gas-cracking")
	ftech.add_prereq("explosives", "flammables")
end

ftech.add_unlock("oil-processing", "solid-fuel-from-butane", 5)

if remix then
	ftech.add_unlock("oil-processing", "carbon", 5)
	ftech.add_unlock("oil-processing", "petroleum-gas", 4)
	
	ftech.add_unlock("sulfur-processing", "sour-gas-sweetening")
	
	ftech.remove_unlock("tungsten-carbide", "carbon")
		
	ftech.add_unlock("advanced-oil-processing", "naphtha-separation", 2)
	ftech.remove_unlock("advanced-oil-processing", "heavy-oil-cracking")
	ftech.remove_unlock("advanced-oil-processing", "light-oil-cracking")
end

ftech.add_unlock("flammables", "methane")
ftech.add_unlock("plastics", "plastic-bar-from-butane")

if (not remix and not settings.startup["scrap-chemistry-sulfur"].value) then
	ftech.add_unlock("sulfur-processing", "sulfur-from-sour-gas")
end

if mods["space-age"] then
	if (remix) then
		ftech.add_unlock("electromagnetic-plant", "methane-electrolysis")
	else
		ftech.add_unlock("space-platform-thruster", "methane-from-carbon", 3)
		ftech.add_unlock("calcite-processing", "sour-gas-sweetening")
		ftech.add_unlock("planet-discovery-aquilo", "hydrazine", 4)
	
		ftech.add_unlock("electromagnetic-plant","electrolyte-souring")
		ftech.add_unlock("electromagnetic-plant", "sour-gas-pollution")
	end

	local coal_liquefaction = data.raw.technology["coal-liquefaction"]
	if coal_liquefaction then
		if remix then
			coal_liquefaction.icon = "__scrap-chemistry__/graphics/technology/remix/coal-liquefaction.png"
		else
			coal_liquefaction.icon = "__scrap-chemistry__/graphics/technology/coal-liquefaction.png"
		end
	end
else
	if (not remix) then
		ftech.add_unlock("sulfur-processing", "sour-gas-sweetening")
		ftech.add_unlock("sulfur-processing", "sour-gas-pollution")
	end
end
