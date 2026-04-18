local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if (remix) then
	data:extend({
		{
			type = "technology",
			name = "tar-processing",
			localised_name = { "technology-name.tar-processing-remix" },
			localised_description = { "technology-description.tar-processing-remix" },
			icon = "__scrap-chemistry__/graphics/technology/remix/tar-processing.png",
			icon_size = 256,
			effects = {
				{type="unlock-recipe", recipe="tar-liquefaction"},
				{type="unlock-recipe", recipe="heavy-oil-cracking"},
				{type="unlock-recipe", recipe="light-oil-cracking"},

				{type="unlock-recipe", recipe="butane-pollution"}
			},
			prerequisites = {"oil-processing"},
			unit = {
				count = 100,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
				},
				time = 30
			}
		}
	})
else
	data:extend({
		{
			type = "technology",
			name = "tar-processing",
			icon = "__scrap-chemistry__/graphics/technology/tar-processing.png",
			icon_size = 256,
			effects = {
				{type="unlock-recipe", recipe="tar"},
				{type="unlock-recipe", recipe="tar-liquefaction"},
				{type="unlock-recipe", recipe="butane-pollution"}
			},
			prerequisites = {"advanced-oil-processing"},
			unit = {
				count = 150,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1}
				},
				time = 30
			}
		}
	})
end
