if (not mods["Voidcraft"]) then return end

local ftech = require("__fdsl__.lib.technology")
local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if (remix) then
	ftech.remove_unlock("sulfur-processing", "carbon")
end