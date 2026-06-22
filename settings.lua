data:extend({
	{
		type = "string-setting",
		name = "scrap-chemistry-recipe-mode",
		setting_type = "startup",
		default_value = "remix",
		allowed_values = {"standard", "remix"},
		order = "a[mode]"
	},
		
	{
		type = "bool-setting",
		name = "scrap-chemistry-cheap-methane",
		setting_type = "startup",
		default_value = false,
		order = "a[mode]-a[remix-settings]-b[methane]"
	},
	
	{
		type = "bool-setting",
		name = "scrap-chemistry-oil-fast",
		setting_type = "startup",
		default_value = true,
		order = "a[mode]-a[remix-settings]-c[speed]"
	},
	
	{
		type = "bool-setting",
		name = "scrap-chemistry-sulfur",
		setting_type = "startup",
		default_value = true,
		order = "a[overhaul]-a[sulfur]"
	},
	{
		type = "bool-setting",
		name = "scrap-chemistry-rocket-fuel",
		setting_type = "startup",
		default_value = true,
		order = "b[other]-a[rocket-fuel]"
	},
	{
		type = "bool-setting",
		name = "scrap-chemistry-butane-realism",
		setting_type = "startup",
		default_value = true,
		order = "a[overhaul]-b[butane]"
	}
})

if mods["space-age"] then
	data:extend({
		{
			type = "bool-setting",
			name = "scrap-chemistry-thruster",
			setting_type = "startup",
			default_value = true,
			order = "c[space-age]-a[thruster-fuel]"
		},
		{
			type = "bool-setting",
			name = "scrap-chemistry-casting-tar",
			setting_type = "startup",
			default_value = true,
			order = "c[space-age]-b[casting-tar]"
		}
	})
end

if mods["AsphaltRoadsPatched"] then
	data:extend({
		{
			type = "string-setting",
			name = "scrap-chemistry-asphalt-compat",
			setting_type = "startup",
			allowed_values = {"replace", "alternative", "none"},
			default_value = "replace",
			order = "m[mods]-a[asphalt]"
		}
	})
end
