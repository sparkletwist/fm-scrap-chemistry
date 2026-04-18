local remix = (settings.startup["scrap-chemistry-recipe-mode"].value == "remix")

if mods["space-age"] then
	ScrapIndustry.products["holmium-solution"] = {type="fluid", priority=2}
	ScrapIndustry.items["electrolyte"] = {scrap="holmium-solution", scale=ScrapIndustry.PRODUCT, failrate=0.01}
	
	if remix then
		ScrapIndustry.recipes["simple-coal-liquefaction"] = {fake_ingredients={}, failrate=0.01}
	end

	if settings.startup["scrap-chemistry-casting-tar"].value then
		ScrapIndustry.items["molten-iron"] = {scrap="tar", scale=ScrapIndustry.FLAVOR, failrate=0.01}
		ScrapIndustry.items["molten-copper"] = {scrap="tar", scale=ScrapIndustry.FLAVOR, failrate=0.01}
	end
end
