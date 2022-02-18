-- weapon data
weapon_data = {
	["sword"] = { ["cooldown"] = 100, ["damage"] = 15, ["graphic"] = "res/gfx/weapons/sword/" },
	["lance"] = { ["cooldown"] = 400, ["damage"] = 30, ["graphic"] = "res/gfx/weapons/lance/" },
	["axe"] = { ["cooldown"] = 300, ["damage"] = 20, ["graphic"] = "res/gfx/weapons/axe/" },
	["rapier"] = { ["cooldown"] = 50, ["damage"] = 8, ["graphic"] = "res/gfx/weapons/rapier/" },
	["sai"] = { ["cooldown"] = 80, ["damage"] = 10, ["graphic"] = "res/gfx/weapons/sai/" },
}

-- UI
ui_data = {
	bar_height = 20,
	health_bar_width = 200,
	energy_bar_width = 140,
	item_box_size = 80,
	font = "res/font/joystix.ttf",
	font_size = 12,
	
	-- general colors
	water_color = { 0.53, 0.7, 0, 0.7 },
	bg_color = { 0.13, 0.13, 0.13 },
	border_color = { 0.067, 0.067, 0.067 },
	text_color = { 0.93, 0.93, 0.93 },
	
	-- ui colors
	health_color = "red",
	energy_color = "blue",
	border_color_active = "gold",
}
