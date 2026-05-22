local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if mods["any-planet-start"] then
	local starting_planet = settings.startup["aps-planet"].value

	if starting_planet == "vulcanus" then
		local tar_processing = data.raw.technology["tar-processing"]
		tar_processing.prerequisites = {"oil-processing"}
		tar_processing.unit = nil
		tar_processing.research_trigger = {
			type = "craft-item",
			item = "tar",
			count = 10
		}
		
	elseif starting_planet == "fulgora" then
		ftech.remove_unlock("calcite-processing", "sour-gas-sweetening")
		ftech.add_unlock("electromagnetic-plant", "sour-gas-sweetening")
	elseif starting_planet == "gleba" then
		if (not remix) then
			ftech.remove_unlock("space-platform-thruster", "methane-from-carbon")
			ftech.add_unlock("biochamber", "methane-from-carbon")
		end
	end
end
