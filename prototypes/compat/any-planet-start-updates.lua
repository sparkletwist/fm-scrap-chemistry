local ftech = require("__fdsl__.lib.technology")

local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if mods["any-planet-start"] then
	local starting_planet = settings.startup["aps-planet"].value

	if starting_planet == "vulcanus" then
		local flammables = data.raw.technology["flammables"]
		flammables.unit = nil
		flammables.research_trigger = {
			type = "craft-fluid",
			fluid = "petroleum-gas"
		}
		ftech.remove_prereq("flammables", "logistic-science-pack")
		
		local sulfur_processing = data.raw.technology["sulfur-processing"]
		sulfur_processing.unit = nil
		sulfur_processing.research_trigger = {
			type = "craft-fluid",
			fluid = "sour-gas"
		}
		ftech.remove_prereq("sulfur-processing", "logistic-science-pack")
	end
end