-- weapon data
weapon_data = {
	["sword"] = { ["cooldown"] = 100, ["damage"] = 15, ["graphic"] = "res/gfx/weapons/sword/" },
	["lance"] = { ["cooldown"] = 400, ["damage"] = 30, ["graphic"] = "res/gfx/weapons/lance/" },
	["axe"] = { ["cooldown"] = 300, ["damage"] = 20, ["graphic"] = "res/gfx/weapons/axe/" },
	["rapier"] = { ["cooldown"] = 50, ["damage"] = 8, ["graphic"] = "res/gfx/weapons/rapier/" },
	["sai"] = { ["cooldown"] = 80, ["damage"] = 10, ["graphic"] = "res/gfx/weapons/sai/" },
}

-- magic
magic_data = {
	["flame"] = { ["strength"] = 5, ["cost"] = 20, ["graphic"] = "res/gfx/particles/flame/fire.png" },
	["heal"] = { ["strength"] = 20, ["cost"] = 10, ["graphic"] = "res/gfx/particles/heal/heal.png" },
}

-- enemy
monster_data = {
	["squid"] = { ["health"] = 100, ["exp"] = 100, ["damage"] = 20, ["attack_type"] = "slash", ["attack_sound"] = "res/sfx/attack/slash.waw", ["speed"] = 30, ["resistance"] = 3, ["attack_radius"] = 80, ["notice_radius"] = 260 },
	["raccoon"] = { ["health"] = 300, ["exp"] = 250, ["damage"] = 20, ["attack_type"] = "claw", ["attack_sound"] = "res/sfx/attack/claw.waw", ["speed"] = 20, ["resistance"] = 3, ["attack_radius"] = 120, ["notice_radius"] = 300 },
	["spirit"] = { ["health"] = 100, ["exp"] = 110, ["damage"] = 20, ["attack_type"] = "thunder", ["attack_sound"] = "res/sfx/attack/fireball.waw", ["speed"] = 40, ["resistance"] = 3, ["attack_radius"] = 60, ["notice_radius"] = 250 },
	["bamboo"] = { ["health"] = 70, ["exp"] = 120, ["damage"] = 20, ["attack_type"] = "leaf_attack", ["attack_sound"] = "res/sfx/attack/slash.waw", ["speed"] = 30, ["resistance"] = 3, ["attack_radius"] = 50, ["notice_radius"] = 200 },
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
	border_color_active = { 1, 0.84, 0 },
}
